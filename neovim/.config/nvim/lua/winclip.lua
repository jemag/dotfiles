-- WSL clipboard provider: OSC 52 for copy, a persistent powershell.exe for paste.
--
-- Replaces the clipipe.exe helper (unsigned third-party binary that trips Defender
-- heuristics). Nothing here runs a non-Microsoft binary.
--
-- Copy goes out as an OSC 52 escape, which herdr captures and forwards to Windows
-- Terminal. That costs no process and no memory. Paste cannot work the same way:
-- Windows Terminal deliberately refuses OSC 52 *read*, and nvim's built-in osc52
-- paste handler waits 10s before giving up, so reads go through powershell instead.
--
-- Measured on this machine:
--   OSC 52 copy                  ~0 ms, 0 MB
--   powershell paste (warm)      ~5-7 ms
--   powershell spawn             ~310 ms, ~73 MB
--   WSL->Windows spawn floor     87-113 ms  (why a persistent helper is required)
--
-- Helper lifetime: spawned lazily on the first paste (a session that never pastes
-- runs no helper at all), reaped after config.idle_reap of inactivity, and gone when
-- nvim exits by any route -- see the VimLeavePre note at the bottom. The one case it
-- outlives nvim is nvim being alive but frozen (SIGSTOP, deadlock): the pipe stays
-- open and the reaper cannot run. That resolves itself when nvim resumes.
if vim.fn.has("wsl") ~= 1 then
  return
end

local M = {}

-- OSC 52 through herdr -> Windows Terminal silently drops payloads whose base64
-- exceeds 256 KiB, i.e. 192 KiB of text. Measured by bisection: 192 KiB passes,
-- 196 KiB does not, and the failure is invisible -- nvim reports success while the
-- clipboard keeps its previous value. Anything at or above this goes to powershell.
local OSC52_MAX_BYTES = 192 * 1024

local SENTINEL = "<<WINCLIP-EOT>>"

local config = {
  timeout = 2000, -- ms to wait for a helper response (4 MiB took 290 ms)
  start_timeout = 5000, -- first request also absorbs the ~310 ms spawn
  interval = 5, -- vim.wait poll granularity; clipipe's 50 was most of its latency
  idle_reap = 120000, -- kill an idle helper after 2 min so background nvims cost 0 MB
}

-- Exposed so these can be tuned or inspected: require("winclip").config.idle_reap = ...
M.config = config

local state = {
  proc = nil,
  buf = {},
  response = nil,
  pending = false,
  first = true,
  timer = nil,
}

local function stop()
  if state.timer then
    state.timer:stop()
    if not state.timer:is_closing() then
      state.timer:close()
    end
    state.timer = nil
  end
  local proc = state.proc
  state.proc = nil
  state.buf = {}
  state.response = nil
  state.pending = false
  state.first = true
  if proc then
    pcall(function()
      proc:kill("sigterm")
    end)
  end
end

-- Restart the idle countdown. Without this the helper would live for the whole
-- session; with it, only a nvim you are actively copying in holds the 73 MB.
local function touch()
  if not state.timer then
    state.timer = vim.uv.new_timer()
  end
  state.timer:stop()
  state.timer:start(config.idle_reap, 0, function()
    vim.schedule(stop)
  end)
end

local function on_stdout(err, data)
  if err or not data then
    return
  end
  table.insert(state.buf, data)
  local all = table.concat(state.buf)
  local s, e = all:find(SENTINEL, 1, true)
  if s then
    state.response = all:sub(1, s - 1)
    local rest = all:sub(e + 1)
    state.buf = #rest > 0 and { rest } or {}
  end
end

local function start()
  if state.proc then
    return true
  end
  state.buf = {}
  state.response = nil
  local ok, proc = pcall(vim.system, {
    "powershell.exe",
    "-NoProfile",
    "-NonInteractive",
    "-Command",
    "-",
  }, {
    -- Do NOT add `detach` here. The child must stay tied to nvim's lifetime: when
    -- nvim dies the OS closes this pipe, powershell reads EOF and exits on its own.
    -- Detaching would silently reintroduce orphaned 73 MB helpers on any unclean exit.
    stdin = true,
    stdout = on_stdout,
    stderr = function() end,
    text = true,
  }, function()
    -- Died (killed externally, Windows session change). Respawn on next use.
    state.proc = nil
  end)
  if not ok then
    vim.notify("winclip: cannot start powershell.exe: " .. tostring(proc), vim.log.levels.ERROR)
    return false
  end
  state.proc = proc
  state.first = true
  -- Without this, non-ASCII comes back mangled.
  pcall(function()
    proc:write("[Console]::OutputEncoding = [System.Text.Encoding]::UTF8\n")
  end)
  return true
end

-- Send one statement, read stdout up to the sentinel. Only one request may be
-- outstanding at a time, otherwise responses cross-talk.
local function transact(ps)
  if not start() then
    return nil
  end
  if state.pending then
    return nil
  end
  state.pending = true
  state.response = nil

  local budget = state.first and config.start_timeout or config.timeout
  state.first = false

  local ok = pcall(function()
    state.proc:write(ps .. '\n; "' .. SENTINEL .. '"\n')
  end)
  if not ok then
    state.pending = false
    stop()
    return nil
  end

  local got = vim.wait(budget, function()
    return state.response ~= nil
  end, config.interval)

  local response = state.response
  state.response = nil
  state.pending = false

  if not got then
    -- The helper is out of sync with us now; drop it rather than desync further.
    stop()
    return nil
  end
  touch()
  return response
end

local function copy_via_powershell(text)
  local ps
  if #text == 0 then
    -- Set-Clipboard rejects an empty string ("Value cannot be null"), but $null
    -- clears cleanly. Measured: both throw-and-clear and clear-quietly exist; this
    -- is the variant that clears without raising.
    ps = "Set-Clipboard -Value $null"
  else
    ps = "$t = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String('"
      .. vim.base64.encode(text)
      .. "')); Set-Clipboard -Value $t"
  end
  if transact(ps) == nil then
    vim.notify(("winclip: failed to copy %d bytes"):format(#text), vim.log.levels.WARN)
  end
end

function M.copy(lines)
  -- Windows apps expect CRLF; clipipe did this conversion in Rust.
  local text = table.concat(lines, "\r\n")

  -- Clearing the clipboard has to go through the helper: an empty OSC 52 payload
  -- is silently ignored by herdr/Windows Terminal (measured), which would leave the
  -- previous contents in place and make a later paste return stale data.
  if #text == 0 then
    copy_via_powershell(text)
    return
  end

  -- Headless nvim has no UI, so nvim_ui_send goes nowhere.
  local has_ui = #vim.api.nvim_list_uis() > 0

  if has_ui and #text < OSC52_MAX_BYTES then
    vim.api.nvim_ui_send("\027]52;c;" .. vim.base64.encode(text) .. "\027\\")
    return
  end
  copy_via_powershell(text)
end

function M.paste()
  local response = transact(
    "$c = Get-Clipboard -Raw; if ($null -eq $c) { $c = '' }; "
      .. "[Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($c))"
  )
  if not response then
    return {}
  end
  local ok, text = pcall(vim.base64.decode, (response:gsub("%s+", "")))
  if not ok or not text then
    return {}
  end
  return vim.split((text:gsub("\r\n", "\n")), "\n", { plain = true })
end

-- Set explicitly: nvim's autodetect would fall through to its own OSC 52 provider,
-- whose paste handler blocks for 10s on a terminal that never answers a read query.
vim.g.clipboard = {
  name = "winclip",
  copy = { ["+"] = M.copy, ["*"] = M.copy },
  paste = { ["+"] = M.paste, ["*"] = M.paste },
}

-- Prompt cleanup on a clean exit. This is not the safety net it looks like: the
-- helper reads stdin, so it exits on EOF within ~0.25s whenever nvim's pipe closes.
-- Measured: `kill -9` on nvim, and killing the WSL /init interop relay (the closest
-- safe proxy for `wsl --shutdown`), both collected the Windows process in under 1s
-- with this autocmd never running. clipipe behaved the same way, for the same reason.
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("winclip", { clear = true }),
  callback = stop,
})

return M

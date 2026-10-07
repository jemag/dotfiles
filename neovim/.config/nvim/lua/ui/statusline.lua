local M = {}

local mode_names = {
  i = "INSERT",
  R = "REPLACE",
  v = "VISUAL",
  V = "V-LINE",
  ["\22"] = "V-BLOCK",
  s = "SELECT",
  S = "S-LINE",
  ["\19"] = "S-BLOCK",
  t = "TERMINAL",
}

-- Cached so statusline redraws never scan the buffer; only search-related events do.
M.search = ""

-- Items normally shown on the last line, which cmdheight=0 hides.
function M.extra()
  local parts = {}

  local mode = mode_names[vim.api.nvim_get_mode().mode:sub(1, 1)]
  if mode then
    parts[#parts + 1] = "%#ModeMsg#" .. mode .. "%*"
  end

  local reg = vim.fn.reg_recording()
  if reg ~= "" then
    parts[#parts + 1] = "%#ErrorMsg#recording @" .. reg .. "%*"
  end

  if vim.v.hlsearch == 1 and M.search ~= "" then
    parts[#parts + 1] = M.search
  end

  return #parts > 0 and table.concat(parts, " ") .. " " or ""
end

local function update_search()
  M.search = ""
  if vim.v.hlsearch == 1 then
    local ok, sc = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 20 })
    if ok and sc.total and sc.total > 0 then
      local total = sc.incomplete == 2 and ">" .. sc.maxcount or sc.total
      M.search = ("[%s/%s]"):format(sc.current, total)
    end
  end
  vim.cmd.redrawstatus()
end

function M.setup()
  -- Keep the built-in default statusline; just inject our items after the %= split.
  local default = vim.api.nvim_get_option_info2("statusline", {}).default
  local item = "%{%v:lua.require'ui.statusline'.extra()%}"
  local s, e = default:find("%=", 1, true)
  vim.o.statusline = s and (default:sub(1, e) .. item .. default:sub(e + 1)) or (item .. default)

  local group = vim.api.nvim_create_augroup("ui_statusline", { clear = true })
  -- RecordingLeave fires while reg_recording() is still set, so redraw on the next tick.
  vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave", "ModeChanged" }, {
    group = group,
    callback = function()
      vim.schedule(function()
        vim.cmd.redrawstatus()
      end)
    end,
  })
  -- Search count follows n/N/*/# and cursor moves between matches. Skipped
  -- entirely when nothing is highlighted, and debounced via vim.schedule.
  local pending = false
  vim.api.nvim_create_autocmd({ "CursorMoved", "CmdlineLeave" }, {
    group = group,
    callback = function()
      if (vim.v.hlsearch == 1 or M.search ~= "") and not pending then
        pending = true
        vim.schedule(function()
          pending = false
          update_search()
        end)
      end
    end,
  })
end

return M

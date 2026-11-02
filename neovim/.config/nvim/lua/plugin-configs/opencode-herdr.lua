-- Report opencode.nvim session state to herdr as this pane's agent.
--
-- opencode v2 runs one background service shared by every client, and that
-- service keeps the environment of whichever client started it, so a
-- server-side plugin cannot tell which herdr pane a session belongs to. herdr's
-- own integration reports only from the opencode TUI, which opencode.nvim never
-- runs. Neovim knows its own pane, so the reporting lives here. It reuses
-- opencode.nvim's per-tab status tracker (the one behind its OSC 7501 output,
-- which herdr does not read). The tracker takes a single listener, so
-- sudo-opencode.lua must keep `program_status.enabled = false`.
--
-- - Label is "opencode-nvim", not "opencode": herdr has a manifest for
--   "opencode" whose screen rules scraping nvim's rendering could contradict
--   these reports (same reasoning as herdr-claude-shim.sh).
-- - Never sends --agent-session-id: a bound agent session makes the pane drop
--   every report, including the nested claude shim's.
local M = {}

local SOURCE = "custom:opencode-nvim"
local AGENT = "opencode-nvim"

-- opencode.nvim record state -> herdr state. "done" is an unseen success, which
-- herdr expresses as idle; an unseen failure needs attention, like a prompt.
local TO_HERDR = { idle = "idle", done = "idle", working = "working", blocked = "blocked", error = "blocked" }
local RANK = { idle = 1, working = 2, blocked = 3 }

local bin, pane = vim.env.HERDR_BIN_PATH, vim.env.HERDR_PANE_ID
local states = {} -- plugin tab id -> herdr state
local reported -- last state sent

-- herdr drops a report whose seq is not greater than the last. Epoch
-- microseconds, strictly increasing, so a later nvim in this pane always
-- outranks an earlier release. "%d" because tostring() would give "1.79e+15";
-- the value is below 2^53 so it is exact.
local last_seq = 0
local function next_seq()
  local sec, usec = vim.uv.gettimeofday()
  last_seq = math.max(last_seq + 1, sec * 1000000 + usec)
  return string.format("%d", last_seq)
end

local function herdr(args, wait)
  pcall(function()
    local job = vim.system(vim.list_extend({ bin, "pane" }, args), { text = true })
    if wait then
      job:wait(1000)
    end
  end)
end

-- One pane, many plugin tabs: report the most urgent. Closing tabs never
-- releases; as before, the agent stays (idle) until nvim exits.
local function on_record(record)
  states[record.id] = record.state ~= "clear" and (TO_HERDR[record.state] or "idle") or nil
  local state = "idle"
  for _, s in pairs(states) do
    if RANK[s] > RANK[state] then
      state = s
    end
  end
  if state == reported then
    return
  end
  reported = state
  herdr({ "report-agent", pane, "--source", SOURCE, "--agent", AGENT, "--state", state, "--seq", next_seq() })
end

-- Mirrors opencode.ui.program_status's private is_seen (minus terminal focus):
-- viewing a session acknowledges its done/error outcome.
local function is_viewed(tab_id)
  local store = require("opencode.state.store")
  local windows = store.get("windows")
  local output = windows and windows.output_win
  return store.get("active_session_tab") == tab_id
    and store.get("is_opencode_focused") == true
    and output ~= nil
    and vim.api.nvim_win_is_valid(output)
    and vim.api.nvim_win_get_tabpage(output) == vim.api.nvim_get_current_tabpage()
end

function M.setup()
  if vim.env.HERDR_ENV ~= "1" or not bin or not pane then
    return
  end
  -- Internal module; re-check after opencode.nvim updates (start(report, is_viewed)).
  require("opencode.services.program_status").start(on_record, is_viewed)

  -- herdr keeps reported state forever with no TTL; release it synchronously so
  -- the pane is not left flagged after nvim is gone.
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = vim.api.nvim_create_augroup("OpencodeHerdrRelease", { clear = true }),
    callback = function()
      herdr({ "release-agent", pane, "--source", SOURCE, "--agent", AGENT, "--seq", next_seq() }, true)
    end,
    desc = "Release herdr opencode agent state on exit",
  })
end

return M

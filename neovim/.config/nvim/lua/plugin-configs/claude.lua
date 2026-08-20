require("claudecode").setup({
  terminal = {
    split_width_percentage = 0.40
  },
})

-- Release the herdr agent that claude-code/.claude/hooks/herdr-claude-shim.sh
-- reports for a claude session running in one of our terminal buffers. That shim
-- owns the pane's agent state outright (herdr has no manifest for the label, so
-- no screen rule can correct it), and its SessionEnd hook does not run when the
-- terminal buffer is killed under claude -- closing the buffer or quitting nvim
-- would otherwise leave the pane showing a dead agent's last state forever.
-- Agent and source must match the shim's AGENT/SOURCE.
--
-- The seq must be nanoseconds since the epoch, on the same clock as the shim's
-- `date +%s%N`: herdr discards reports whose seq trails the last one it accepted,
-- so a monotonic-since-boot clock like vim.uv.hrtime() is silently ignored. It is
-- also formatted digit by digit because epoch nanoseconds exceed what a Lua
-- number holds exactly, and tostring() would hand herdr "1.7864e+18".
local function herdr_seq()
  local sec, usec = vim.uv.gettimeofday()
  return string.format("%d%06d000", sec, usec)
end

local function herdr_release_claude()
  local pane = vim.env.HERDR_PANE_ID
  if vim.env.HERDR_ENV ~= "1" or not pane or pane == "" then
    return
  end
  local herdr = vim.env.HERDR_BIN_PATH
  if not herdr or herdr == "" then
    herdr = "herdr"
  end
  if vim.fn.executable(herdr) == 0 then
    return
  end
  -- Fire and forget: a release that fails is not worth blocking :q on.
  pcall(vim.system, {
    herdr,
    "pane",
    "release-agent",
    pane,
    "--source",
    "custom:claude-nvim",
    "--agent",
    "claude-nvim",
    "--seq",
    herdr_seq(),
  }, { text = true })
end

local herdrClaudeAugroup = vim.api.nvim_create_augroup("HerdrClaudeRelease", { clear = true })
vim.api.nvim_create_autocmd("TermClose", {
  group = herdrClaudeAugroup,
  pattern = "term://*claude*",
  callback = herdr_release_claude,
  desc = "Release the herdr agent when a claude terminal closes",
})
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = herdrClaudeAugroup,
  pattern = "*",
  callback = herdr_release_claude,
  desc = "Release the herdr agent for a nested claude session on exit",
})


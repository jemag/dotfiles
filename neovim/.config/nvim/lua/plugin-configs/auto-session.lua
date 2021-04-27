local opts = {
  -- Sets the log level of the plugin (debug, info, error)
  logLevel = vim.g.auto_session_log_level  or 'info',
  -- Root dir where sessions will be stored
  auto_session_root_dir = vim.fn.stdpath('data').."/sessions/",
  -- Enables/disables auto save/restore
  auto_session_enabled = false,
  pre_save_cmds = {"lua require('scrollbar').clear()", "echo 'saving hook'"}
}

require('auto-session').setup(opts)

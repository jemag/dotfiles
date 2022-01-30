local opts = {
	logLevel = vim.g.auto_session_log_level or "info",
	auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
	auto_save_enabled = true,
	pre_save_cmds = { ":ScrollViewDisable", "echo 'saving hook'" },
}

require("auto-session").setup(opts)

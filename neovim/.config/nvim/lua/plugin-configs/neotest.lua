local neotest_ns = vim.api.nvim_create_namespace("neotest")
vim.diagnostic.config({
  virtual_text = {
    format = function(diagnostic)
      local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
      return message
    end,
  },
}, neotest_ns)
require("neotest").setup({
  adapters = {
    require("neotest-dart"),
    require("neotest-dotnet"),
    require("neotest-elixir"),
    -- `dap_mode = "manual"` is required: the default "dap-go" mode calls
    -- `require("dap-go").setup()` and hard-errors if that plugin is missing.
    -- In manual mode neotest-golang supplies `program` (an absolute package dir)
    -- and appends `-test.run <regex>` itself; we only provide the static fields.
    --
    -- `dap_manual_config` must be a *function*. Upstream does
    -- `table.insert(cfg.args, "-test.run", regex)` on whatever it gets back, so a
    -- plain table (the same object every run) accumulates args without bound --
    -- and debugging a whole package skips that insert, leaving a stale
    -- `-test.run` behind that would silently re-run only the previous test.
    require("neotest-golang")({
      dap_mode = "manual",
      dap_manual_config = function()
        return {
          type = "go",
          name = "Neotest golang",
          request = "launch",
          mode = "test",
          outputMode = "remote",
          args = { "-test.v" },
          -- `setup_debugging()` sets `cwd` on the throwaway table this function
          -- returns, so we set it ourselves. This is the current buffer's package
          -- dir, which matches neotest-golang's own value whenever the run is
          -- triggered from the test file.
          cwd = vim.fn.expand("%:p:h"),
        }
      end,
    }),
    require("neotest-java")({
      ignore_wrapper = false,
    }),
    require("neotest-jest"),
    require("neotest-phpunit"),
    require("neotest-python"),
    require("neotest-rust"),
    require("neotest-zig"),
  },
})


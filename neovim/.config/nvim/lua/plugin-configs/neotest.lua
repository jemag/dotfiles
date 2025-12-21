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
    require("neotest-go"),
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


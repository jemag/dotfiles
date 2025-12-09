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

vim.keymap.set("n", "<localleader>ns", function()
  require("neotest").run.stop()
end, { desc = "Stop unit" })

vim.keymap.set("n", "<localleader>nru", function()
  require("neotest").run.run()
end, { desc = "Unit" })

vim.keymap.set("n", "<localleader>nrf", function()
  require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "File" })

vim.keymap.set("n", "<localleader>nrp", function()
  require("neotest").run.run(vim.fn.getcwd())
end, { desc = "Project" })

vim.keymap.set("n", "<localleader>nrd", function()
  require("neotest").run.run(vim.fn.expand("%:p:h"))
end, { desc = "Directory" })

vim.keymap.set("n", "<localleader>nwu", function()
  require("neotest").watch.toggle()
end, { desc = "Unit" })

vim.keymap.set("n", "<localleader>nwf", function()
  require("neotest").watch.toggle(vim.fn.expand("%"))
end, { desc = "File" })

vim.keymap.set("n", "<localleader>nwp", function()
  require("neotest").watch.toggle(vim.fn.getcwd())
end, { desc = "Project" })

vim.keymap.set("n", "<localleader>nwd", function()
  require("neotest").watch.toggle(vim.fn.expand("%:p:h"))
end, { desc = "Directory" })

vim.keymap.set("n", "<localleader>nD", function()
  require("neotest").run.run({ strategy = "dap" })
end, { desc = "Unit in debugger" })

vim.keymap.set("n", "<localleader>nt", function()
  require("neotest").summary.toggle()
end, { desc = "neotest summary" })

vim.keymap.set("n", "<localleader>nT", function()
  require("neotest").output_panel.toggle()
end, { desc = "output panel" })

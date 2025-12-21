M = {}

M.obsidian = function()
  vim.keymap.set("n", "<leader>ob", "<cmd>Obsidian backlinks<cr>", { desc = "Backlinks" })
  vim.keymap.set("x", "<leader>oe", ":Obsidian extract_note<cr>", { desc = "Extract to note" })
  vim.keymap.set("n", "<leader>og", "<cmd>Obsidian search<cr>", { desc = "Grep in notes" })
  vim.keymap.set("n", "<leader>on", "<cmd>Obsidian new<cr>", { desc = "New note" })
  vim.keymap.set("n", "<leader>oo", "<cmd>Obsidian open<cr>", { desc = "Open" })
  vim.keymap.set("n", "<leader>or", "<cmd>Obsidian rename<cr>", { desc = "Rename note" })
  vim.keymap.set("n", "<leader>oq", "<cmd>Obsidian quick_switch<cr>", { desc = "Obidian.nvim quick switch" })
  vim.keymap.set("n", "<leader>ot", "<cmd>Obsidian tags<cr>", { desc = "Tags" })
  vim.keymap.set("n", "<leader>oT", "<cmd>Obsidian new_from_template<cr>", { desc = "Template" })
  vim.keymap.set("n", "<leader>oy", "<cmd>Obsidian yesterday<cr>", { desc = "Yesterday" })
  vim.keymap.set("n", "<leader>os", function()
    require("snacks.picker").files({ cwd = vim.env.OBSIDIAN_VAULT, args = { "--glob", "*.md" } })
  end, { desc = "Quick switch" })
end

M.neotest = function()
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
end

return M

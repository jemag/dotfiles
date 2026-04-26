require("godoc").setup({
  adapters = {
    {
      name = "go",
      opts = {
        command = "GoDoc",
        get_syntax_info = function()
          return {
            filetype = "godoc",
            language = "godoc",
          }
        end,
      },
    },
  },
  window = {
    type = "vsplit",
  },
  picker = {
    type = "snacks",
  },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "godoc",
  callback = function(ev)
    vim.schedule(function()
      vim.keymap.del("n", "<Esc>", { buffer = ev.buf })
    end)
  end,
})

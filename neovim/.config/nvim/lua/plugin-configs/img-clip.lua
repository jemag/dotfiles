require("img-clip").setup({
  dir_path = ".attachments",
  markdown = {
    url_encode_path = true,
    template = "![$CURSOR](/$FILE_PATH)",
  },
})

vim.keymap.set({ "n" }, "<localleader>mpa", "<cmd>PasteImage<cr>", { desc = "Paste image into .attachments directory" })
vim.keymap.set({ "n" }, "<localleader>mpg", function()
  require("img-clip").pasteImage({
    use_absolute_path = false,
    dir_path = ".attachments",
    prompt_for_file_name = true,
    show_dir_path_in_prompt = true,
    markdown = {
      url_encode_path = true,
      template = "![$CURSOR]($FILE_PATH)",
    },
  })
end, { desc = "Paste image into prompted directory" })

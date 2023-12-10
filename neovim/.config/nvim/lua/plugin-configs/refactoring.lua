require("refactoring").setup({
  prompt_func_return_type = {
    go = true,
    java = false,

    cpp = false,
    c = false,
    h = false,
    hpp = false,
    cxx = false,
  },
  prompt_func_param_type = {
    go = true,
    java = false,

    cpp = false,
    c = false,
    h = false,
    hpp = false,
    cxx = false,
  },
  printf_statements = {},
  print_var_statements = {},
})

-- -- telescope refactoring helper
-- local function refactor(prompt_bufnr)
--   local content = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
--   require("telescope.actions").close(prompt_bufnr)
--   require("refactoring").refactor(content.value)
-- end
--
-- -- NOTE: M is a global object
-- -- for the sake of simplicity in this example
-- -- you can extract this function and the helper above
-- -- and then require the file and call the extracted function
-- -- in the mappings below

-- M = {}
-- M.refactors = function()
--   local opts = require("telescope.themes").get_cursor() -- set personal telescope options
--   require("telescope.pickers").new(opts, {
--     prompt_title = "refactors",
--     finder = require("telescope.finders").new_table({
--       results = require("refactoring").get_refactors(),
--     }),
--     sorter = require("telescope.config").values.generic_sorter(opts),
--     attach_mappings = function(_, map)
--       map("i", "<CR>", refactor)
--       map("n", "<CR>", refactor)
--       return true
--     end,
--   }):find()
-- end
-- Remaps for the refactoring operations currently offered by the plugin
vim.keymap.set("x", "<leader>re", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]],
  { desc = "Extract function" })
vim.keymap.set(
  "x",
  "<leader>rf",
  [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
  { desc = "Extract function to file" }
)
vim.keymap.set("x", "<leader>rv", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]],
  { desc = "Extract variable" })
vim.keymap.set("x", "<leader>ri", [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
  { desc = "Inline variable" })

-- Extract block doesn't need visual mode
vim.keymap.set("n", "<leader>rb", [[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]],
  { desc = "Extract block" })
-- vim.keymap.set("n", "<leader>rbf", [[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]], { desc ="Extract block to file"})

-- Inline variable can also pick up the identifier currently under the cursor without visual mode
vim.keymap.set("n", "<leader>ri", [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
  { desc = "Inline variable" })

-- Print function
-- You can also use below = true here to to change the position of the printf
-- statement (or set two remaps for either one). This remap must be made in normal mode.
vim.api.nvim_set_keymap(
  "n",
  "<leader>rp",
  ":lua require('refactoring').debug.printf({below = false})<CR>",
  { noremap = true, desc = "Print function call" }
)

-- Print var
-- Remap in normal mode and passing { normal = true } will automatically find the variable under the cursor and print it
vim.api.nvim_set_keymap(
  "n",
  "<leader>rv",
  ":lua require('refactoring').debug.print_var({ normal = true })<CR>",
  { noremap = true, desc = "Print variable" }
)
-- Remap in visual mode will print whatever is in the visual selection
vim.api.nvim_set_keymap(
  "v",
  "<leader>rv",
  ":lua require('refactoring').debug.print_var({})<CR>",
  { noremap = true, desc = "Print variable" }
)

-- Cleanup function: this remap should be made in normal mode
vim.api.nvim_set_keymap(
  "n",
  "<leader>rC",
  ":lua require('refactoring').debug.cleanup({})<CR>",
  { noremap = true, desc = "Clean up print statements" }
)

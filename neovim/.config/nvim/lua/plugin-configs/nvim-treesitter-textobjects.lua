require("nvim-treesitter-textobjects").setup({
  textobjects = {
    select = {
      lookahead = true,
    },
    move = {
      set_jumps = true,
    },
  },
})

local function ts_move(fn_name, query)
  return function()
    pcall(require("nvim-treesitter-textobjects.move")[fn_name], query)
  end
end

local function ts_select(query)
  return function()
    pcall(require("nvim-treesitter-textobjects.select").select_textobject, query, "textobjects")
  end
end

vim.keymap.set({"x", "o" }, "af", ts_select("@function.outer"), { desc = "Select around function" })
vim.keymap.set({"x", "o" }, "if", ts_select("@function.inner"), { desc = "Select inner function" })
vim.keymap.set({"x", "o" }, "ao", ts_select("@class.outer"), { desc = "Select around class" })
vim.keymap.set({"x", "o" }, "io", ts_select("@class.inner"), { desc = "Select inner class" })
vim.keymap.set({"x", "o" }, "ac", ts_select("@conditional.outer"), { desc = "Select around conditional" })
vim.keymap.set({"x", "o" }, "ic", ts_select("@conditional.inner"), { desc = "Select inner conditional" })
vim.keymap.set({"x", "o" }, "ae", ts_select("@block.outer"), { desc = "Select around block" })
vim.keymap.set({"x", "o" }, "ie", ts_select("@block.inner"), { desc = "Select inner block" })
vim.keymap.set({"x", "o" }, "al", ts_select("@loop.outer"), { desc = "Select around loop" })
vim.keymap.set({"x", "o" }, "il", ts_select("@loop.inner"), { desc = "Select inner loop" })
vim.keymap.set({"x", "o" }, "aa", ts_select("@parameter.outer"), { desc = "Select around parameter" })
vim.keymap.set({"x", "o" }, "ia", ts_select("@parameter.inner"), { desc = "Select inner parameter" })
vim.keymap.set({"x", "o" }, "as", ts_select("@statement.outer"), { desc = "Select around statement" })
vim.keymap.set({"x", "o" }, "ak", ts_select("@comment.outer"), { desc = "Select around comment" })
vim.keymap.set({"x", "o" }, "am", ts_select("@call.outer"), { desc = "Select around call" })
vim.keymap.set({"x", "o" }, "im", ts_select("@call.inner"), { desc = "Select inner call" })

vim.keymap.set({ "n", "x", "o" }, "]f", ts_move("goto_next_start", "@function.outer"), { desc = "Next function start" })
vim.keymap.set({ "n", "x", "o" }, "]o", ts_move("goto_next_start", "@class.outer"), { desc = "Next class start" })
vim.keymap.set({ "n", "x", "o" }, "]a", ts_move("goto_next_start", "@parameter.inner"), { desc = "Next parameter start" })
vim.keymap.set({ "n", "x", "o" }, "[f", ts_move("goto_previous_start", "@function.outer"), { desc = "Previous function start" })
vim.keymap.set({ "n", "x", "o" }, "[o", ts_move("goto_previous_start", "@class.outer"), { desc = "Previous class start" })
vim.keymap.set({ "n", "x", "o" }, "[a", ts_move("goto_previous_start", "@parameter.inner"), { desc = "Previous parameter start" })
vim.keymap.set({ "n", "x", "o" }, "]F", ts_move("goto_next_end", "@function.outer"), { desc = "Next function end" })
vim.keymap.set({ "n", "x", "o" }, "]O", ts_move("goto_next_end", "@class.outer"), { desc = "Next class end" })
vim.keymap.set({ "n", "x", "o" }, "]A", ts_move("goto_next_end", "@parameter.inner"), { desc = "Next parameter end" })
vim.keymap.set({ "n", "x", "o" }, "[F", ts_move("goto_previous_end", "@function.outer"), { desc = "Previous function end" })
vim.keymap.set({ "n", "x", "o" }, "[O", ts_move("goto_previous_end", "@class.outer"), { desc = "Previous class end" })
vim.keymap.set({ "n", "x", "o" }, "[A", ts_move("goto_previous_end", "@parameter.inner"), { desc = "Previous parameter end" })

require("bookmarks").setup({
  -- sign_priority = 8,  --set bookmark sign priority to cover other sign
  -- save_file = vim.fn.expand "$HOME/.bookmarks", -- bookmarks save file path
  scoped = true,
  keywords = {
    ["@t"] = "☑️ ", -- mark annotation startswith @t ,signs this icon as `Todo`
    ["@w"] = "⚠️ ", -- mark annotation startswith @w ,signs this icon as `Warn`
    ["@f"] = "⛏ ", -- mark annotation startswith @f ,signs this icon as `Fix`
    ["@n"] = " ", -- mark annotation startswith @n ,signs this icon as `Note`
  },
  on_attach = function(bufnr)
    local bm = require("bookmarks")
    vim.keymap.set("n", "mt", bm.bookmark_toggle, { desc = "toggle bookmark" }) -- add or remove bookmark at current line
    vim.keymap.set("n", "mi", bm.bookmark_ann, { desc = "annotate bookmark" }) -- add or edit mark annotation at current line
    vim.keymap.set("n", "mc", bm.bookmark_clean, { desc = "clean buffer bookmarks" }) -- clean all marks in local buffer
    vim.keymap.set("n", "[m", bm.bookmark_prev, { desc = "prev bookmark" }) -- jump to previous mark in local buffer
    vim.keymap.set("n", "]m", bm.bookmark_next, { desc = "next bookmark" }) -- jump to next mark in local buffer
    -- vim.keymap.set("n", "mx", bm.bookmark_clear_all, { desc = "clear all bookmarks" }) -- jump to next mark in local buffer
    vim.keymap.set("n", "ml", "<cmd>Telescope bookmarks list<cr>", { desc = "List bookmarks" })
  end,
})

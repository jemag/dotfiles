require("markdown-plus").setup({
  keymaps = {
    enabled = false, -- Disable all default keymaps
  },
  filetypes = {"markdown", "text", "txt"},
})
-- Normal mode
vim.keymap.set({"n", "x"}, "<localleader>nb", "<Plug>(MarkdownPlusBold)")
vim.keymap.set({"n", "x"}, "<localleader>ni", "<Plug>(MarkdownPlusItalic)")
vim.keymap.set({"n", "x"}, "<localleader>ns", "<Plug>(MarkdownPlusStrikethrough)")
vim.keymap.set({"n", "x"}, "<localleader>nc", "<Plug>(MarkdownPlusCode)")
vim.keymap.set({"n", "x"}, "<localleader>nC", "<Plug>(MarkdownPlusClearFormatting)")
vim.keymap.set("x", "<localleader>nw", "<Plug>(MarkdownPlusCodeBlock)")

vim.keymap.set("n", "]]", "<Plug>(MarkdownPlusNextHeader)")
vim.keymap.set("n", "[[", "<Plug>(MarkdownPlusPrevHeader)")
vim.keymap.set("n", "<leader>h+", "<Plug>(MarkdownPlusPromoteHeader)")
vim.keymap.set("n", "<leader>h-", "<Plug>(MarkdownPlusDemoteHeader)")
vim.keymap.set("n", "<leader>ht", "<Plug>(MarkdownPlusGenerateTOC)")
vim.keymap.set("n", "<leader>hu", "<Plug>(MarkdownPlusUpdateTOC)")
vim.keymap.set("n", "<leader>hT", "<Plug>(MarkdownPlusOpenTocWindow)")
vim.keymap.set("n", "gd", "<Plug>(MarkdownPlusFollowLink)")  -- Follow TOC link

-- Header levels (H1-H6)
for i = 1, 6 do
  vim.keymap.set("n", "<leader>h" .. i, "<Plug>(MarkdownPlusHeader" .. i .. ")")
end

vim.keymap.set("n", "<localleader>nl", "<Plug>(MarkdownPlusInsertLink)")
vim.keymap.set("v", "<localleader>nl", "<Plug>(MarkdownPlusSelectionToLink)")
vim.keymap.set("n", "<localleader>ne", "<Plug>(MarkdownPlusEditLink)")
vim.keymap.set("n", "<localleader>nR", "<Plug>(MarkdownPlusConvertToReference)")
vim.keymap.set("n", "<localleader>nI", "<Plug>(MarkdownPlusConvertToInline)")
vim.keymap.set("n", "<localleader>na", "<Plug>(MarkdownPlusAutoLinkURL)")

vim.keymap.set("n", "<localleader>nL", "<Plug>(MarkdownPlusInsertImage)")
vim.keymap.set("v", "<localleader>nL", "<Plug>(MarkdownPlusSelectionToImage)")
vim.keymap.set("n", "<localleader>nE", "<Plug>(MarkdownPlusEditImage)")
vim.keymap.set("n", "<localleader>nA", "<Plug>(MarkdownPlusToggleImageLink)")

-- Insert mode
vim.keymap.set("i", "<CR>", "<Plug>(MarkdownPlusListEnter)")
vim.keymap.set("i", "<Tab>", "<Plug>(MarkdownPlusListIndent)")
vim.keymap.set("i", "<S-Tab>", "<Plug>(MarkdownPlusListOutdent)")
vim.keymap.set("i", "<BS>", "<Plug>(MarkdownPlusListBackspace)")
vim.keymap.set("i", "<C-t>", "<Plug>(MarkdownPlusToggleCheckbox)")

-- Normal mode
vim.keymap.set("n", "<localleader>nr", "<Plug>(MarkdownPlusRenumberLists)")
vim.keymap.set("n", "<localleader>nd", "<Plug>(MarkdownPlusDebugLists)")
vim.keymap.set("n", "o", "<Plug>(MarkdownPlusNewListItemBelow)")
vim.keymap.set("n", "O", "<Plug>(MarkdownPlusNewListItemAbove)")
vim.keymap.set("n", "<localleader>nx", "<Plug>(MarkdownPlusToggleCheckbox)")

-- Visual mode
vim.keymap.set("x", "<localleader>nx", "<Plug>(MarkdownPlusToggleCheckbox)")

-- Normal mode
vim.keymap.set("n", "<localleader>nq", "<Plug>(MarkdownPlusToggleQuote)")
-- Visual mode
vim.keymap.set("x", "<localleader>nq", "<Plug>(MarkdownPlusToggleQuote)")

-- Normal mode - Insert callout
vim.keymap.set("n", "<localleader>nQi", "<Plug>(MarkdownPlusInsertCallout)")
-- Visual mode - Wrap selection in callout
vim.keymap.set("x", "<localleader>nQi", "<Plug>(MarkdownPlusInsertCallout)")

-- Toggle callout type (cycle through types)
vim.keymap.set("n", "<localleader>nQt", "<Plug>(MarkdownPlusToggleCalloutType)")

-- Convert blockquote to callout
vim.keymap.set("n", "<localleader>nQc", "<Plug>(MarkdownPlusConvertToCallout)")

-- Convert callout to blockquote
vim.keymap.set("n", "<localleader>nQb", "<Plug>(MarkdownPlusConvertToBlockquote)")

vim.keymap.set("n", "<localleader>nfi", "<Plug>(MarkdownPlusFootnoteInsert)")
vim.keymap.set("n", "<localleader>nfe", "<Plug>(MarkdownPlusFootnoteEdit)")
vim.keymap.set("n", "<localleader>nfd", "<Plug>(MarkdownPlusFootnoteDelete)")
vim.keymap.set("n", "<localleader>nfg", "<Plug>(MarkdownPlusFootnoteGotoDefinition)")
vim.keymap.set("n", "<localleader>nfr", "<Plug>(MarkdownPlusFootnoteGotoReference)")
vim.keymap.set("n", "<localleader>nfn", "<Plug>(MarkdownPlusFootnoteNext)")
vim.keymap.set("n", "<localleader>nfp", "<Plug>(MarkdownPlusFootnotePrev)")
vim.keymap.set("n", "<localleader>nfl", "<Plug>(MarkdownPlusFootnoteList)")

-- Table operations with different prefix
vim.keymap.set("n", "<leader>tc", "<Plug>(markdown-plus-table-create)")
vim.keymap.set("n", "<leader>tf", "<Plug>(markdown-plus-table-format)")
vim.keymap.set("n", "<leader>tn", "<Plug>(markdown-plus-table-normalize)")

-- Row operations
vim.keymap.set("n", "<leader>tir", "<Plug>(markdown-plus-table-insert-row-below)")
vim.keymap.set("n", "<leader>tiR", "<Plug>(markdown-plus-table-insert-row-above)")
vim.keymap.set("n", "<leader>tdr", "<Plug>(markdown-plus-table-delete-row)")
vim.keymap.set("n", "<leader>tyr", "<Plug>(markdown-plus-table-duplicate-row)")

-- Column operations
vim.keymap.set("n", "<leader>tic", "<Plug>(markdown-plus-table-insert-column-right)")
vim.keymap.set("n", "<leader>tiC", "<Plug>(markdown-plus-table-insert-column-left)")
vim.keymap.set("n", "<leader>tdc", "<Plug>(markdown-plus-table-delete-column)")
vim.keymap.set("n", "<leader>tyc", "<Plug>(markdown-plus-table-duplicate-column)")

-- Additional table operations
vim.keymap.set("n", "<leader>ta", "<Plug>(markdown-plus-table-toggle-cell-alignment)")
vim.keymap.set("n", "<leader>tx", "<Plug>(markdown-plus-table-clear-cell)")
vim.keymap.set("n", "<leader>tmh", "<Plug>(markdown-plus-table-move-column-left)")
vim.keymap.set("n", "<leader>tml", "<Plug>(markdown-plus-table-move-column-right)")
vim.keymap.set("n", "<leader>tmk", "<Plug>(markdown-plus-table-move-row-up)")
vim.keymap.set("n", "<leader>tmj", "<Plug>(markdown-plus-table-move-row-down)")
vim.keymap.set("n", "<leader>tt", "<Plug>(markdown-plus-table-transpose)")
vim.keymap.set("n", "<leader>tsa", "<Plug>(markdown-plus-table-sort-ascending)")
vim.keymap.set("n", "<leader>tsd", "<Plug>(markdown-plus-table-sort-descending)")
vim.keymap.set("n", "<leader>tvx", "<Plug>(markdown-plus-table-to-csv)")
vim.keymap.set("n", "<leader>tvi", "<Plug>(markdown-plus-table-from-csv)")

-- Insert mode table navigation
vim.keymap.set("i", "<A-h>", "<Plug>(markdown-plus-table-move-left)")
vim.keymap.set("i", "<A-l>", "<Plug>(markdown-plus-table-move-right)")
vim.keymap.set("i", "<A-j>", "<Plug>(markdown-plus-table-move-down)")
vim.keymap.set("i", "<A-k>", "<Plug>(markdown-plus-table-move-up)")

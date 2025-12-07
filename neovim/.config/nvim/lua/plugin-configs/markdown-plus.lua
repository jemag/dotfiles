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

vim.keymap.set("n", "gn", "<Plug>(MarkdownPlusNextHeader)")
vim.keymap.set("n", "gp", "<Plug>(MarkdownPlusPrevHeader)")
vim.keymap.set("n", "<leader>h+", "<Plug>(MarkdownPlusPromoteHeader)")
vim.keymap.set("n", "<leader>h-", "<Plug>(MarkdownPlusDemoteHeader)")
vim.keymap.set("n", "<leader>ht", "<Plug>(MarkdownPlusGenerateTOC)")
vim.keymap.set("n", "<leader>hu", "<Plug>(MarkdownPlusUpdateTOC)")
vim.keymap.set("n", "<leader>hT", "<Plug>(MarkdownPlusOpenTocWindow)")
vim.keymap.set("n", "<CR>", "<Plug>(MarkdownPlusFollowLink)")  -- Follow TOC link

-- Header levels (H1-H6)
for i = 1, 6 do
  vim.keymap.set("n", "<leader>" .. i, "<Plug>(MarkdownPlusHeader" .. i .. ")")
end

vim.keymap.set("n", "<leader>li", "<Plug>(MarkdownPlusInsertLink)")
vim.keymap.set("v", "<leader>li", "<Plug>(MarkdownPlusSelectionToLink)")
vim.keymap.set("n", "<leader>le", "<Plug>(MarkdownPlusEditLink)")
vim.keymap.set("n", "<leader>lr", "<Plug>(MarkdownPlusConvertToReference)")
vim.keymap.set("n", "<leader>ln", "<Plug>(MarkdownPlusConvertToInline)")
vim.keymap.set("n", "<leader>la", "<Plug>(MarkdownPlusAutoLinkURL)")

vim.keymap.set("n", "<leader>mL", "<Plug>(MarkdownPlusInsertImage)")
vim.keymap.set("v", "<leader>mL", "<Plug>(MarkdownPlusSelectionToImage)")
vim.keymap.set("n", "<leader>mE", "<Plug>(MarkdownPlusEditImage)")
vim.keymap.set("n", "<leader>mA", "<Plug>(MarkdownPlusToggleImageLink)")

-- Insert mode
vim.keymap.set("i", "<C-CR>", "<Plug>(MarkdownPlusListEnter)")
vim.keymap.set("i", "<A-CR>", "<Plug>(MarkdownPlusListShiftEnter)")
vim.keymap.set("i", "<C-]>", "<Plug>(MarkdownPlusListIndent)")
vim.keymap.set("i", "<C-[>", "<Plug>(MarkdownPlusListOutdent)")
vim.keymap.set("i", "<C-h>", "<Plug>(MarkdownPlusListBackspace)")
vim.keymap.set("i", "<C-t>", "<Plug>(MarkdownPlusToggleCheckbox)")

-- Normal mode
vim.keymap.set("n", "<leader>lr", "<Plug>(MarkdownPlusRenumberLists)")
vim.keymap.set("n", "<leader>ld", "<Plug>(MarkdownPlusDebugLists)")
vim.keymap.set("n", "o", "<Plug>(MarkdownPlusNewListItemBelow)")
vim.keymap.set("n", "O", "<Plug>(MarkdownPlusNewListItemAbove)")
vim.keymap.set("n", "<leader>mx", "<Plug>(MarkdownPlusToggleCheckbox)")

-- Visual mode
vim.keymap.set("x", "<leader>mx", "<Plug>(MarkdownPlusToggleCheckbox)")

-- Normal mode
vim.keymap.set("n", "<C-q>", "<Plug>(MarkdownPlusToggleQuote)")
-- Visual mode
vim.keymap.set("x", "<C-q>", "<Plug>(MarkdownPlusToggleQuote)")

-- Normal mode - Insert callout
vim.keymap.set("n", "<leader>mc", "<Plug>(MarkdownPlusInsertCallout)")
-- Visual mode - Wrap selection in callout
vim.keymap.set("x", "<leader>mc", "<Plug>(MarkdownPlusInsertCallout)")

-- Toggle callout type (cycle through types)
vim.keymap.set("n", "<leader>mC", "<Plug>(MarkdownPlusToggleCalloutType)")

-- Convert blockquote to callout
vim.keymap.set("n", "<leader>m>c", "<Plug>(MarkdownPlusConvertToCallout)")

-- Convert callout to blockquote
vim.keymap.set("n", "<leader>m>b", "<Plug>(MarkdownPlusConvertToBlockquote)")

vim.keymap.set("n", "<leader>fi", "<Plug>(MarkdownPlusFootnoteInsert)")
vim.keymap.set("n", "<leader>fe", "<Plug>(MarkdownPlusFootnoteEdit)")
vim.keymap.set("n", "<leader>fd", "<Plug>(MarkdownPlusFootnoteDelete)")
vim.keymap.set("n", "<leader>fg", "<Plug>(MarkdownPlusFootnoteGotoDefinition)")
vim.keymap.set("n", "<leader>fr", "<Plug>(MarkdownPlusFootnoteGotoReference)")
vim.keymap.set("n", "<leader>fn", "<Plug>(MarkdownPlusFootnoteNext)")
vim.keymap.set("n", "<leader>fp", "<Plug>(MarkdownPlusFootnotePrev)")
vim.keymap.set("n", "<leader>fl", "<Plug>(MarkdownPlusFootnoteList)")

-- Table operations with different prefix
vim.keymap.set("n", "<leader>Tc", "<Plug>(markdown-plus-table-create)")
vim.keymap.set("n", "<leader>Tf", "<Plug>(markdown-plus-table-format)")
vim.keymap.set("n", "<leader>Tn", "<Plug>(markdown-plus-table-normalize)")

-- Row operations
vim.keymap.set("n", "<leader>Tir", "<Plug>(markdown-plus-table-insert-row-below)")
vim.keymap.set("n", "<leader>TiR", "<Plug>(markdown-plus-table-insert-row-above)")
vim.keymap.set("n", "<leader>Tdr", "<Plug>(markdown-plus-table-delete-row)")
vim.keymap.set("n", "<leader>Tyr", "<Plug>(markdown-plus-table-duplicate-row)")

-- Column operations
vim.keymap.set("n", "<leader>Tic", "<Plug>(markdown-plus-table-insert-column-right)")
vim.keymap.set("n", "<leader>TiC", "<Plug>(markdown-plus-table-insert-column-left)")
vim.keymap.set("n", "<leader>Tdc", "<Plug>(markdown-plus-table-delete-column)")
vim.keymap.set("n", "<leader>Tyc", "<Plug>(markdown-plus-table-duplicate-column)")

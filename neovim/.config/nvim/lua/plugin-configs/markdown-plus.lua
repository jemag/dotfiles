require("markdown-plus").setup({
  keymaps = {
    enabled = false, -- Disable all default keymaps
  },
  filetypes = {"markdown", "text", "txt"},
})
-- Normal mode
vim.keymap.set({"n", "x"}, "<leader>mb", "<Plug>(MarkdownPlusBold)")
vim.keymap.set({"n", "x"}, "<leader>mi", "<Plug>(MarkdownPlusItalic)")
vim.keymap.set({"n", "x"}, "<leader>ms", "<Plug>(MarkdownPlusStrikethrough)")
vim.keymap.set({"n", "x"}, "<leader>mc", "<Plug>(MarkdownPlusCode)")
vim.keymap.set({"n", "x"}, "<leader>mC", "<Plug>(MarkdownPlusClearFormatting)")
vim.keymap.set("x", "<leader>mw", "<Plug>(MarkdownPlusCodeBlock)")

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

vim.keymap.set("n", "<leader>ml", "<Plug>(MarkdownPlusInsertLink)")
vim.keymap.set("v", "<leader>ml", "<Plug>(MarkdownPlusSelectionToLink)")
vim.keymap.set("n", "<leader>me", "<Plug>(MarkdownPlusEditLink)")
vim.keymap.set("n", "<leader>mR", "<Plug>(MarkdownPlusConvertToReference)")
vim.keymap.set("n", "<leader>mI", "<Plug>(MarkdownPlusConvertToInline)")
vim.keymap.set("n", "<leader>ma", "<Plug>(MarkdownPlusAutoLinkURL)")

vim.keymap.set("n", "<leader>mL", "<Plug>(MarkdownPlusInsertImage)")
vim.keymap.set("v", "<leader>mL", "<Plug>(MarkdownPlusSelectionToImage)")
vim.keymap.set("n", "<leader>mE", "<Plug>(MarkdownPlusEditImage)")
vim.keymap.set("n", "<leader>mA", "<Plug>(MarkdownPlusToggleImageLink)")

-- Insert mode
vim.keymap.set("i", "<CR>", "<Plug>(MarkdownPlusListEnter)")
vim.keymap.set("i", "<A-CR>", "<Plug>(MarkdownPlusListShiftEnter)")
vim.keymap.set("i", "<Tab>", "<Plug>(MarkdownPlusListIndent)")
vim.keymap.set("i", "<S-Tab>", "<Plug>(MarkdownPlusListOutdent)")
vim.keymap.set("i", "<BS>", "<Plug>(MarkdownPlusListBackspace)")
vim.keymap.set("i", "<C-t>", "<Plug>(MarkdownPlusToggleCheckbox)")

-- Normal mode
vim.keymap.set("n", "<leader>mr", "<Plug>(MarkdownPlusRenumberLists)")
vim.keymap.set("n", "<leader>md", "<Plug>(MarkdownPlusDebugLists)")
vim.keymap.set("n", "o", "<Plug>(MarkdownPlusNewListItemBelow)")
vim.keymap.set("n", "O", "<Plug>(MarkdownPlusNewListItemAbove)")
vim.keymap.set("n", "<leader>mx", "<Plug>(MarkdownPlusToggleCheckbox)")

-- Visual mode
vim.keymap.set("x", "<leader>mx", "<Plug>(MarkdownPlusToggleCheckbox)")

-- Normal mode
vim.keymap.set("n", "<leader>mq", "<Plug>(MarkdownPlusToggleQuote)")
-- Visual mode
vim.keymap.set("x", "<leader>mq", "<Plug>(MarkdownPlusToggleQuote)")

-- Normal mode - Insert callout
vim.keymap.set("n", "<leader>mQi", "<Plug>(MarkdownPlusInsertCallout)")
-- Visual mode - Wrap selection in callout
vim.keymap.set("x", "<leader>mQi", "<Plug>(MarkdownPlusInsertCallout)")

-- Toggle callout type (cycle through types)
vim.keymap.set("n", "<leader>mQt", "<Plug>(MarkdownPlusToggleCalloutType)")

-- Convert blockquote to callout
vim.keymap.set("n", "<leader>mQc", "<Plug>(MarkdownPlusConvertToCallout)")

-- Convert callout to blockquote
vim.keymap.set("n", "<leader>mQb", "<Plug>(MarkdownPlusConvertToBlockquote)")

vim.keymap.set("n", "<leader>mfi", "<Plug>(MarkdownPlusFootnoteInsert)")
vim.keymap.set("n", "<leader>mfe", "<Plug>(MarkdownPlusFootnoteEdit)")
vim.keymap.set("n", "<leader>mfd", "<Plug>(MarkdownPlusFootnoteDelete)")
vim.keymap.set("n", "<leader>mfg", "<Plug>(MarkdownPlusFootnoteGotoDefinition)")
vim.keymap.set("n", "<leader>mfr", "<Plug>(MarkdownPlusFootnoteGotoReference)")
vim.keymap.set("n", "<leader>mfn", "<Plug>(MarkdownPlusFootnoteNext)")
vim.keymap.set("n", "<leader>mfp", "<Plug>(MarkdownPlusFootnotePrev)")
vim.keymap.set("n", "<leader>mfl", "<Plug>(MarkdownPlusFootnoteList)")

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

require("markdown-plus").setup({
  keymaps = {
    enabled = false, -- Disable all default keymaps
  },
  filetypes = {"markdown", "text", "txt"},
})
-- Text Formatting (Normal & Visual Mode)
vim.keymap.set({"n", "x"}, "<leader>nb", "<Plug>(MarkdownPlusBold)", { desc = "Toggle bold formatting" })
vim.keymap.set({"n", "x"}, "<leader>ni", "<Plug>(MarkdownPlusItalic)", { desc = "Toggle italic formatting" })
vim.keymap.set({"n", "x"}, "<leader>ns", "<Plug>(MarkdownPlusStrikethrough)", { desc = "Toggle strikethrough formatting" })
vim.keymap.set({"n", "x"}, "<leader>nc", "<Plug>(MarkdownPlusCode)", { desc = "Toggle inline code formatting" })
vim.keymap.set({"n", "x"}, "<leader>nC", "<Plug>(MarkdownPlusClearFormatting)", { desc = "Clear all formatting" })
vim.keymap.set("x", "<leader>nw", "<Plug>(MarkdownPlusCodeBlock)", { desc = "Convert selection to code block" })

-- Headers & TOC Navigation
vim.keymap.set("n", "<leader>nht", "<Plug>(MarkdownPlusGenerateTOC)", { desc = "Generate table of contents" })
vim.keymap.set("n", "<leader>nhu", "<Plug>(MarkdownPlusUpdateTOC)", { desc = "Update existing table of contents" })
vim.keymap.set("n", "<leader>nhT", "<Plug>(MarkdownPlusOpenTocWindow)", { desc = "Open navigable TOC window" })

-- Header Levels (H1-H6)
for i = 1, 6 do
  vim.keymap.set("n", "<leader>nh" .. i, "<Plug>(MarkdownPlusHeader" .. i .. ")", { desc = "Set header level to H" .. i })
end

-- Links Management
vim.keymap.set("n", "<leader>nl", "<Plug>(MarkdownPlusInsertLink)", { desc = "Insert new markdown link" })
vim.keymap.set("x", "<leader>nl", "<Plug>(MarkdownPlusSelectionToLink)", { desc = "Convert selection to link" })
vim.keymap.set("n", "<leader>nR", "<Plug>(MarkdownPlusConvertToReference)", { desc = "Convert to reference-style link" })
vim.keymap.set("n", "<leader>nI", "<Plug>(MarkdownPlusConvertToInline)", { desc = "Convert to inline link" })
vim.keymap.set("n", "<leader>na", "<Plug>(MarkdownPlusAutoLinkURL)", { desc = "Auto-convert URL to markdown link" })

-- Images Management
vim.keymap.set("n", "<leader>nL", "<Plug>(MarkdownPlusInsertImage)", { desc = "Insert new markdown image" })
vim.keymap.set("x", "<leader>nL", "<Plug>(MarkdownPlusSelectionToImage)", { desc = "Convert selection to image" })
vim.keymap.set("n", "<leader>nE", "<Plug>(MarkdownPlusEditImage)", { desc = "Edit image under cursor" })
vim.keymap.set("n", "<leader>nA", "<Plug>(MarkdownPlusToggleImageLink)", { desc = "Toggle between link and image" })

-- List Management (Insert Mode)
vim.keymap.set("i", "<CR>", "<Plug>(MarkdownPlusListEnter)", { desc = "Auto-continue list or break out" })
vim.keymap.set("i", "<Tab>", "<Plug>(MarkdownPlusListIndent)", { desc = "Indent list item" })
vim.keymap.set("i", "<S-Tab>", "<Plug>(MarkdownPlusListOutdent)", { desc = "Outdent list item" })
vim.keymap.set("i", "<BS>", "<Plug>(MarkdownPlusListBackspace)", { desc = "Smart backspace for lists" })
vim.keymap.set("i", "<C-b>", "<Plug>(MarkdownPlusToggleCheckbox)", { desc = "Toggle checkbox in insert mode" })

-- List Management (Normal & Visual Mode)
vim.keymap.set("n", "<leader>nr", "<Plug>(MarkdownPlusRenumberLists)", { desc = "Renumber ordered lists" })
vim.keymap.set("n", "o", "<Plug>(MarkdownPlusNewListItemBelow)", { desc = "Create new list item below" })
vim.keymap.set("n", "O", "<Plug>(MarkdownPlusNewListItemAbove)", { desc = "Create new list item above" })
vim.keymap.set({"n", "x"}, "<leader>nx", "<Plug>(MarkdownPlusToggleCheckbox)", { desc = "Toggle checkbox on current line" })

-- Quotes Management (Normal & Visual Mode)
vim.keymap.set({"n", "x"}, "<leader>nq", "<Plug>(MarkdownPlusToggleQuote)", { desc = "Toggle blockquote" })

-- Callouts/Admonitions (Normal & Visual Mode)
vim.keymap.set("n", "<leader>nQi", "<Plug>(MarkdownPlusInsertCallout)", { desc = "Insert callout (prompts for type)" })
vim.keymap.set("x", "<leader>nQi", "<Plug>(MarkdownPlusInsertCallout)", { desc = "Wrap selection in callout" })
vim.keymap.set("n", "<leader>nQt", "<Plug>(MarkdownPlusToggleCalloutType)", { desc = "Toggle/cycle callout type" })
vim.keymap.set("n", "<leader>nQc", "<Plug>(MarkdownPlusConvertToCallout)", { desc = "Convert blockquote to callout" })
vim.keymap.set("n", "<leader>nQb", "<Plug>(MarkdownPlusConvertToBlockquote)", { desc = "Convert callout to blockquote" })

-- Footnotes Management
vim.keymap.set("n", "<leader>nfi", "<Plug>(MarkdownPlusFootnoteInsert)", { desc = "Insert new footnote" })
vim.keymap.set("n", "<leader>nfe", "<Plug>(MarkdownPlusFootnoteEdit)", { desc = "Edit footnote definition" })
vim.keymap.set("n", "<leader>nfd", "<Plug>(MarkdownPlusFootnoteDelete)", { desc = "Delete footnote (ref & definition)" })
vim.keymap.set("n", "<leader>nfg", "<Plug>(MarkdownPlusFootnoteGotoDefinition)", { desc = "Go to footnote definition" })
vim.keymap.set("n", "<leader>nfr", "<Plug>(MarkdownPlusFootnoteGotoReference)", { desc = "Go to footnote reference(s)" })
vim.keymap.set("n", "<leader>nfn", "<Plug>(MarkdownPlusFootnoteNext)", { desc = "Navigate to next footnote" })
vim.keymap.set("n", "<leader>nfp", "<Plug>(MarkdownPlusFootnotePrev)", { desc = "Navigate to previous footnote" })
vim.keymap.set("n", "<leader>nfl", "<Plug>(MarkdownPlusFootnoteList)", { desc = "List all footnotes" })

-- Tables - Basic Operations
vim.keymap.set("n", "<leader>zc", "<Plug>(markdown-plus-table-create)", { desc = "Create table interactively" })
vim.keymap.set("n", "<leader>zf", "<Plug>(markdown-plus-table-format)", { desc = "Format table at cursor" })
vim.keymap.set("n", "<leader>zn", "<Plug>(markdown-plus-table-normalize)", { desc = "Normalize malformed table" })

-- Tables - Row Operations
vim.keymap.set("n", "<leader>zir", "<Plug>(markdown-plus-table-insert-row-below)", { desc = "Insert row below current" })
vim.keymap.set("n", "<leader>ziR", "<Plug>(markdown-plus-table-insert-row-above)", { desc = "Insert row above current" })
vim.keymap.set("n", "<leader>zdr", "<Plug>(markdown-plus-table-delete-row)", { desc = "Delete current row" })
vim.keymap.set("n", "<leader>zyr", "<Plug>(markdown-plus-table-duplicate-row)", { desc = "Duplicate current row" })

-- Tables - Column Operations
vim.keymap.set("n", "<leader>zic", "<Plug>(markdown-plus-table-insert-column-right)", { desc = "Insert column to right" })
vim.keymap.set("n", "<leader>ziC", "<Plug>(markdown-plus-table-insert-column-left)", { desc = "Insert column to left" })
vim.keymap.set("n", "<leader>zdc", "<Plug>(markdown-plus-table-delete-column)", { desc = "Delete current column" })
vim.keymap.set("n", "<leader>zyc", "<Plug>(markdown-plus-table-duplicate-column)", { desc = "Duplicate current column" })

-- Tables - Advanced Operations
vim.keymap.set("n", "<leader>za", "<Plug>(markdown-plus-table-toggle-cell-alignment)", { desc = "Toggle cell alignment (left/center/right)" })
vim.keymap.set("n", "<leader>zx", "<Plug>(markdown-plus-table-clear-cell)", { desc = "Clear current cell content" })
vim.keymap.set("n", "<leader>zmh", "<Plug>(markdown-plus-table-move-column-left)", { desc = "Move column left" })
vim.keymap.set("n", "<leader>zml", "<Plug>(markdown-plus-table-move-column-right)", { desc = "Move column right" })
vim.keymap.set("n", "<leader>zmk", "<Plug>(markdown-plus-table-move-row-up)", { desc = "Move row up" })
vim.keymap.set("n", "<leader>zmj", "<Plug>(markdown-plus-table-move-row-down)", { desc = "Move row down" })
vim.keymap.set("n", "<leader>zt", "<Plug>(markdown-plus-table-transpose)", { desc = "Transpose table (swap rows/columns)" })
vim.keymap.set("n", "<leader>zsa", "<Plug>(markdown-plus-table-sort-ascending)", { desc = "Sort table by column (ascending)" })
vim.keymap.set("n", "<leader>zsd", "<Plug>(markdown-plus-table-sort-descending)", { desc = "Sort table by column (descending)" })
vim.keymap.set("n", "<leader>zvx", "<Plug>(markdown-plus-table-to-csv)", { desc = "Convert table to CSV" })
vim.keymap.set("n", "<leader>zvi", "<Plug>(markdown-plus-table-from-csv)", { desc = "Convert CSV to table" })

-- Tables - Insert Mode Navigation with proper override options
vim.keymap.set("i", "<C-Left>", "<Plug>(markdown-plus-table-nav-left)", { desc = "Move to cell on the left" })
vim.keymap.set("i", "<C-Right>", "<Plug>(markdown-plus-table-nav-right)", { desc = "Move to cell on the right" })
vim.keymap.set("i", "<C-Down>", "<Plug>(markdown-plus-table-nav-down)", { desc = "Move to cell below" })
vim.keymap.set("i", "<C-Up>", "<Plug>(markdown-plus-table-nav-up)", { desc = "Move to cell above" })

require("markdown-plus").setup({
  keymaps = {
    enabled = false, -- Disable all default keymaps
  },
  filetypes = {"markdown", "text", "txt"},
})
-- Text Formatting (Normal & Visual Mode)
vim.keymap.set({"n", "x"}, "<localleader>nb", "<Plug>(MarkdownPlusBold)", { desc = "Toggle bold formatting" })
vim.keymap.set({"n", "x"}, "<localleader>ni", "<Plug>(MarkdownPlusItalic)", { desc = "Toggle italic formatting" })
vim.keymap.set({"n", "x"}, "<localleader>ns", "<Plug>(MarkdownPlusStrikethrough)", { desc = "Toggle strikethrough formatting" })
vim.keymap.set({"n", "x"}, "<localleader>nc", "<Plug>(MarkdownPlusCode)", { desc = "Toggle inline code formatting" })
vim.keymap.set({"n", "x"}, "<localleader>nC", "<Plug>(MarkdownPlusClearFormatting)", { desc = "Clear all formatting" })
vim.keymap.set("x", "<localleader>nw", "<Plug>(MarkdownPlusCodeBlock)", { desc = "Convert selection to code block" })

-- Headers & TOC Navigation
vim.keymap.set("n", "<localleader>nht", "<Plug>(MarkdownPlusGenerateTOC)", { desc = "Generate table of contents" })
vim.keymap.set("n", "<localleader>nhu", "<Plug>(MarkdownPlusUpdateTOC)", { desc = "Update existing table of contents" })
vim.keymap.set("n", "<localleader>nhT", "<Plug>(MarkdownPlusOpenTocWindow)", { desc = "Open navigable TOC window" })

-- Header Levels (H1-H6)
for i = 1, 6 do
  vim.keymap.set("n", "<localleader>nh" .. i, "<Plug>(MarkdownPlusHeader" .. i .. ")", { desc = "Set header level to H" .. i })
end

-- Links Management
vim.keymap.set("n", "<localleader>nl", "<Plug>(MarkdownPlusInsertLink)", { desc = "Insert new markdown link" })
vim.keymap.set("x", "<localleader>nl", "<Plug>(MarkdownPlusSelectionToLink)", { desc = "Convert selection to link" })
vim.keymap.set("n", "<localleader>nR", "<Plug>(MarkdownPlusConvertToReference)", { desc = "Convert to reference-style link" })
vim.keymap.set("n", "<localleader>nI", "<Plug>(MarkdownPlusConvertToInline)", { desc = "Convert to inline link" })
vim.keymap.set("n", "<localleader>na", "<Plug>(MarkdownPlusAutoLinkURL)", { desc = "Auto-convert URL to markdown link" })

-- Images Management
vim.keymap.set("n", "<localleader>nL", "<Plug>(MarkdownPlusInsertImage)", { desc = "Insert new markdown image" })
vim.keymap.set("x", "<localleader>nL", "<Plug>(MarkdownPlusSelectionToImage)", { desc = "Convert selection to image" })
vim.keymap.set("n", "<localleader>nE", "<Plug>(MarkdownPlusEditImage)", { desc = "Edit image under cursor" })
vim.keymap.set("n", "<localleader>nA", "<Plug>(MarkdownPlusToggleImageLink)", { desc = "Toggle between link and image" })

-- List Management (Insert Mode)
vim.keymap.set("i", "<CR>", "<Plug>(MarkdownPlusListEnter)", { desc = "Auto-continue list or break out" })
vim.keymap.set("i", "<Tab>", "<Plug>(MarkdownPlusListIndent)", { desc = "Indent list item" })
vim.keymap.set("i", "<S-Tab>", "<Plug>(MarkdownPlusListOutdent)", { desc = "Outdent list item" })
vim.keymap.set("i", "<BS>", "<Plug>(MarkdownPlusListBackspace)", { desc = "Smart backspace for lists" })
vim.keymap.set("i", "<C-b>", "<Plug>(MarkdownPlusToggleCheckbox)", { desc = "Toggle checkbox in insert mode" })

-- List Management (Normal & Visual Mode)
vim.keymap.set("n", "<localleader>nr", "<Plug>(MarkdownPlusRenumberLists)", { desc = "Renumber ordered lists" })
vim.keymap.set("n", "o", "<Plug>(MarkdownPlusNewListItemBelow)", { desc = "Create new list item below" })
vim.keymap.set("n", "O", "<Plug>(MarkdownPlusNewListItemAbove)", { desc = "Create new list item above" })
vim.keymap.set({"n", "x"}, "<localleader>nx", "<Plug>(MarkdownPlusToggleCheckbox)", { desc = "Toggle checkbox on current line" })

-- Quotes Management (Normal & Visual Mode)
vim.keymap.set("n", "<localleader>nq", "<Plug>(MarkdownPlusToggleQuote)", { desc = "Toggle blockquote on current line" })
vim.keymap.set("x", "<localleader>nq", "<Plug>(MarkdownPlusToggleQuote)", { desc = "Toggle blockquote on selected lines" })

-- Callouts/Admonitions (Normal & Visual Mode)
vim.keymap.set("n", "<localleader>nQi", "<Plug>(MarkdownPlusInsertCallout)", { desc = "Insert callout (prompts for type)" })
vim.keymap.set("x", "<localleader>nQi", "<Plug>(MarkdownPlusInsertCallout)", { desc = "Wrap selection in callout" })
vim.keymap.set("n", "<localleader>nQt", "<Plug>(MarkdownPlusToggleCalloutType)", { desc = "Toggle/cycle callout type" })
vim.keymap.set("n", "<localleader>nQc", "<Plug>(MarkdownPlusConvertToCallout)", { desc = "Convert blockquote to callout" })
vim.keymap.set("n", "<localleader>nQb", "<Plug>(MarkdownPlusConvertToBlockquote)", { desc = "Convert callout to blockquote" })

-- Footnotes Management
vim.keymap.set("n", "<localleader>nfi", "<Plug>(MarkdownPlusFootnoteInsert)", { desc = "Insert new footnote" })
vim.keymap.set("n", "<localleader>nfe", "<Plug>(MarkdownPlusFootnoteEdit)", { desc = "Edit footnote definition" })
vim.keymap.set("n", "<localleader>nfd", "<Plug>(MarkdownPlusFootnoteDelete)", { desc = "Delete footnote (ref & definition)" })
vim.keymap.set("n", "<localleader>nfg", "<Plug>(MarkdownPlusFootnoteGotoDefinition)", { desc = "Go to footnote definition" })
vim.keymap.set("n", "<localleader>nfr", "<Plug>(MarkdownPlusFootnoteGotoReference)", { desc = "Go to footnote reference(s)" })
vim.keymap.set("n", "<localleader>nfn", "<Plug>(MarkdownPlusFootnoteNext)", { desc = "Navigate to next footnote" })
vim.keymap.set("n", "<localleader>nfp", "<Plug>(MarkdownPlusFootnotePrev)", { desc = "Navigate to previous footnote" })
vim.keymap.set("n", "<localleader>nfl", "<Plug>(MarkdownPlusFootnoteList)", { desc = "List all footnotes" })

-- Tables - Basic Operations
vim.keymap.set("n", "<leader>tc", "<Plug>(markdown-plus-table-create)", { desc = "Create table interactively" })
vim.keymap.set("n", "<leader>tf", "<Plug>(markdown-plus-table-format)", { desc = "Format table at cursor" })
vim.keymap.set("n", "<leader>tn", "<Plug>(markdown-plus-table-normalize)", { desc = "Normalize malformed table" })

-- Tables - Row Operations
vim.keymap.set("n", "<leader>tir", "<Plug>(markdown-plus-table-insert-row-below)", { desc = "Insert row below current" })
vim.keymap.set("n", "<leader>tiR", "<Plug>(markdown-plus-table-insert-row-above)", { desc = "Insert row above current" })
vim.keymap.set("n", "<leader>tdr", "<Plug>(markdown-plus-table-delete-row)", { desc = "Delete current row" })
vim.keymap.set("n", "<leader>tyr", "<Plug>(markdown-plus-table-duplicate-row)", { desc = "Duplicate current row" })

-- Tables - Column Operations
vim.keymap.set("n", "<leader>tic", "<Plug>(markdown-plus-table-insert-column-right)", { desc = "Insert column to right" })
vim.keymap.set("n", "<leader>tiC", "<Plug>(markdown-plus-table-insert-column-left)", { desc = "Insert column to left" })
vim.keymap.set("n", "<leader>tdc", "<Plug>(markdown-plus-table-delete-column)", { desc = "Delete current column" })
vim.keymap.set("n", "<leader>tyc", "<Plug>(markdown-plus-table-duplicate-column)", { desc = "Duplicate current column" })

-- Tables - Advanced Operations
vim.keymap.set("n", "<leader>ta", "<Plug>(markdown-plus-table-toggle-cell-alignment)", { desc = "Toggle cell alignment (left/center/right)" })
vim.keymap.set("n", "<leader>tx", "<Plug>(markdown-plus-table-clear-cell)", { desc = "Clear current cell content" })
vim.keymap.set("n", "<leader>tmh", "<Plug>(markdown-plus-table-move-column-left)", { desc = "Move column left" })
vim.keymap.set("n", "<leader>tml", "<Plug>(markdown-plus-table-move-column-right)", { desc = "Move column right" })
vim.keymap.set("n", "<leader>tmk", "<Plug>(markdown-plus-table-move-row-up)", { desc = "Move row up" })
vim.keymap.set("n", "<leader>tmj", "<Plug>(markdown-plus-table-move-row-down)", { desc = "Move row down" })
vim.keymap.set("n", "<leader>tt", "<Plug>(markdown-plus-table-transpose)", { desc = "Transpose table (swap rows/columns)" })
vim.keymap.set("n", "<leader>tsa", "<Plug>(markdown-plus-table-sort-ascending)", { desc = "Sort table by column (ascending)" })
vim.keymap.set("n", "<leader>tsd", "<Plug>(markdown-plus-table-sort-descending)", { desc = "Sort table by column (descending)" })
vim.keymap.set("n", "<leader>tvx", "<Plug>(markdown-plus-table-to-csv)", { desc = "Convert table to CSV" })
vim.keymap.set("n", "<leader>tvi", "<Plug>(markdown-plus-table-from-csv)", { desc = "Convert CSV to table" })

-- Tables - Insert Mode Navigation
vim.keymap.set("i", "<A-h>", "<Plug>(markdown-plus-table-move-left)", { desc = "Move to cell on the left" })
vim.keymap.set("i", "<A-l>", "<Plug>(markdown-plus-table-move-right)", { desc = "Move to cell on the right" })
vim.keymap.set("i", "<A-j>", "<Plug>(markdown-plus-table-move-down)", { desc = "Move to cell below" })
vim.keymap.set("i", "<A-k>", "<Plug>(markdown-plus-table-move-up)", { desc = "Move to cell above" })

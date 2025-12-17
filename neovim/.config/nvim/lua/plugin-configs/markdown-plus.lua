require("markdown-plus").setup({
  keymaps = {
    enabled = false, -- Disable all default keymaps
  },
  filetypes = {"markdown", "text", "txt"},
})

local function setup_markdown_keybinds()
  -- Text Formatting (Normal & Visual Mode)
  vim.keymap.set({"n", "x"}, "<leader>nb", "<Plug>(MarkdownPlusBold)", { buffer = true, desc = "Toggle bold formatting" })
  vim.keymap.set({"n", "x"}, "<leader>ni", "<Plug>(MarkdownPlusItalic)", { buffer = true, desc = "Toggle italic formatting" })
  vim.keymap.set({"n", "x"}, "<leader>ns", "<Plug>(MarkdownPlusStrikethrough)", { buffer = true, desc = "Toggle strikethrough formatting" })
  vim.keymap.set({"n", "x"}, "<leader>nc", "<Plug>(MarkdownPlusCode)", { buffer = true, desc = "Toggle inline code formatting" })
  vim.keymap.set({"n", "x"}, "<leader>nC", "<Plug>(MarkdownPlusClearFormatting)", { buffer = true, desc = "Clear all formatting" })
  vim.keymap.set("x", "<leader>nw", "<Plug>(MarkdownPlusCodeBlock)", { buffer = true, desc = "Convert selection to code block" })

  -- Headers & TOC Navigation
  vim.keymap.set("n", "<leader>nht", "<Plug>(MarkdownPlusGenerateTOC)", { buffer = true, desc = "Generate table of contents" })
  vim.keymap.set("n", "<leader>nhu", "<Plug>(MarkdownPlusUpdateTOC)", { buffer = true, desc = "Update existing table of contents" })
  vim.keymap.set("n", "<leader>nhT", "<Plug>(MarkdownPlusOpenTocWindow)", { buffer = true, desc = "Open navigable TOC window" })

  -- Header Levels (H1-H6)
  for i = 1, 6 do
    vim.keymap.set("n", "<leader>nh" .. i, "<Plug>(MarkdownPlusHeader" .. i .. ")", { buffer = true, desc = "Set header level to H" .. i })
  end

  -- Links Management
  vim.keymap.set("n", "<leader>nl", "<Plug>(MarkdownPlusInsertLink)", { buffer = true, desc = "Insert new markdown link" })
  vim.keymap.set("x", "<leader>nl", "<Plug>(MarkdownPlusSelectionToLink)", { buffer = true, desc = "Convert selection to link" })
  vim.keymap.set("n", "<leader>nR", "<Plug>(MarkdownPlusConvertToReference)", { buffer = true, desc = "Convert to reference-style link" })
  vim.keymap.set("n", "<leader>nI", "<Plug>(MarkdownPlusConvertToInline)", { buffer = true, desc = "Convert to inline link" })
  vim.keymap.set("n", "<leader>na", "<Plug>(MarkdownPlusAutoLinkURL)", { buffer = true, desc = "Auto-convert URL to markdown link" })

  -- Images Management
  vim.keymap.set("n", "<leader>nL", "<Plug>(MarkdownPlusInsertImage)", { buffer = true, desc = "Insert new markdown image" })
  vim.keymap.set("x", "<leader>nL", "<Plug>(MarkdownPlusSelectionToImage)", { buffer = true, desc = "Convert selection to image" })
  vim.keymap.set("n", "<leader>nE", "<Plug>(MarkdownPlusEditImage)", { buffer = true, desc = "Edit image under cursor" })
  vim.keymap.set("n", "<leader>nA", "<Plug>(MarkdownPlusToggleImageLink)", { buffer = true, desc = "Toggle between link and image" })

  -- List Management (Insert Mode)
  vim.keymap.set("i", "<CR>", "<Plug>(MarkdownPlusListEnter)", { buffer = true, desc = "Auto-continue list or break out" })
  vim.keymap.set("i", "<Tab>", "<Plug>(MarkdownPlusListIndent)", { buffer = true, desc = "Indent list item" })
  vim.keymap.set("i", "<S-Tab>", "<Plug>(MarkdownPlusListOutdent)", { buffer = true, desc = "Outdent list item" })
  vim.keymap.set("i", "<BS>", "<Plug>(MarkdownPlusListBackspace)", { buffer = true, desc = "Smart backspace for lists" })
  vim.keymap.set("i", "<C-b>", "<Plug>(MarkdownPlusToggleCheckbox)", { buffer = true, desc = "Toggle checkbox in insert mode" })

  -- List Management (Normal & Visual Mode)
  vim.keymap.set("n", "<leader>nr", "<Plug>(MarkdownPlusRenumberLists)", { buffer = true, desc = "Renumber ordered lists" })
  vim.keymap.set("n", "o", "<Plug>(MarkdownPlusNewListItemBelow)", { buffer = true, desc = "Create new list item below" })
  vim.keymap.set("n", "O", "<Plug>(MarkdownPlusNewListItemAbove)", { buffer = true, desc = "Create new list item above" })
  vim.keymap.set({"n", "x"}, "<leader>nx", "<Plug>(MarkdownPlusToggleCheckbox)", { buffer = true, desc = "Toggle checkbox on current line" })

  -- Quotes Management (Normal & Visual Mode)
  vim.keymap.set({"n", "x"}, "<leader>nq", "<Plug>(MarkdownPlusToggleQuote)", { buffer = true, desc = "Toggle blockquote" })

  -- Callouts/Admonitions (Normal & Visual Mode)
  vim.keymap.set("n", "<leader>nQi", "<Plug>(MarkdownPlusInsertCallout)", { buffer = true, desc = "Insert callout (prompts for type)" })
  vim.keymap.set("x", "<leader>nQi", "<Plug>(MarkdownPlusInsertCallout)", { buffer = true, desc = "Wrap selection in callout" })
  vim.keymap.set("n", "<leader>nQt", "<Plug>(MarkdownPlusToggleCalloutType)", { buffer = true, desc = "Toggle/cycle callout type" })
  vim.keymap.set("n", "<leader>nQc", "<Plug>(MarkdownPlusConvertToCallout)", { buffer = true, desc = "Convert blockquote to callout" })
  vim.keymap.set("n", "<leader>nQb", "<Plug>(MarkdownPlusConvertToBlockquote)", { buffer = true, desc = "Convert callout to blockquote" })

  -- Footnotes Management
  vim.keymap.set("n", "<leader>nfi", "<Plug>(MarkdownPlusFootnoteInsert)", { buffer = true, desc = "Insert new footnote" })
  vim.keymap.set("n", "<leader>nfe", "<Plug>(MarkdownPlusFootnoteEdit)", { buffer = true, desc = "Edit footnote definition" })
  vim.keymap.set("n", "<leader>nfd", "<Plug>(MarkdownPlusFootnoteDelete)", { buffer = true, desc = "Delete footnote (ref & definition)" })
  vim.keymap.set("n", "<leader>nfg", "<Plug>(MarkdownPlusFootnoteGotoDefinition)", { buffer = true, desc = "Go to footnote definition" })
  vim.keymap.set("n", "<leader>nfr", "<Plug>(MarkdownPlusFootnoteGotoReference)", { buffer = true, desc = "Go to footnote reference(s)" })
  vim.keymap.set("n", "<leader>nfn", "<Plug>(MarkdownPlusFootnoteNext)", { buffer = true, desc = "Navigate to next footnote" })
  vim.keymap.set("n", "<leader>nfp", "<Plug>(MarkdownPlusFootnotePrev)", { buffer = true, desc = "Navigate to previous footnote" })
  vim.keymap.set("n", "<leader>nfl", "<Plug>(MarkdownPlusFootnoteList)", { buffer = true, desc = "List all footnotes" })

  -- Tables - Basic Operations
  vim.keymap.set("n", "<leader>zc", "<Plug>(markdown-plus-table-create)", { buffer = true, desc = "Create table interactively" })
  vim.keymap.set("n", "<leader>zf", "<Plug>(markdown-plus-table-format)", { buffer = true, desc = "Format table at cursor" })
  vim.keymap.set("n", "<leader>zn", "<Plug>(markdown-plus-table-normalize)", { buffer = true, desc = "Normalize malformed table" })

  -- Tables - Row Operations
  vim.keymap.set("n", "<leader>zir", "<Plug>(markdown-plus-table-insert-row-below)", { buffer = true, desc = "Insert row below current" })
  vim.keymap.set("n", "<leader>ziR", "<Plug>(markdown-plus-table-insert-row-above)", { buffer = true, desc = "Insert row above current" })
  vim.keymap.set("n", "<leader>zdr", "<Plug>(markdown-plus-table-delete-row)", { buffer = true, desc = "Delete current row" })
  vim.keymap.set("n", "<leader>zyr", "<Plug>(markdown-plus-table-duplicate-row)", { buffer = true, desc = "Duplicate current row" })

  -- Tables - Column Operations
  vim.keymap.set("n", "<leader>zic", "<Plug>(markdown-plus-table-insert-column-right)", { buffer = true, desc = "Insert column to right" })
  vim.keymap.set("n", "<leader>ziC", "<Plug>(markdown-plus-table-insert-column-left)", { buffer = true, desc = "Insert column to left" })
  vim.keymap.set("n", "<leader>zdc", "<Plug>(markdown-plus-table-delete-column)", { buffer = true, desc = "Delete current column" })
  vim.keymap.set("n", "<leader>zyc", "<Plug>(markdown-plus-table-duplicate-column)", { buffer = true, desc = "Duplicate current column" })

  -- Tables - Advanced Operations
  vim.keymap.set("n", "<leader>za", "<Plug>(markdown-plus-table-toggle-cell-alignment)", { buffer = true, desc = "Toggle cell alignment (left/center/right)" })
  vim.keymap.set("n", "<leader>zx", "<Plug>(markdown-plus-table-clear-cell)", { buffer = true, desc = "Clear current cell content" })
  vim.keymap.set("n", "<leader>zmh", "<Plug>(markdown-plus-table-move-column-left)", { buffer = true, desc = "Move column left" })
  vim.keymap.set("n", "<leader>zml", "<Plug>(markdown-plus-table-move-column-right)", { buffer = true, desc = "Move column right" })
  vim.keymap.set("n", "<leader>zmk", "<Plug>(markdown-plus-table-move-row-up)", { buffer = true, desc = "Move row up" })
  vim.keymap.set("n", "<leader>zmj", "<Plug>(markdown-plus-table-move-row-down)", { buffer = true, desc = "Move row down" })
  vim.keymap.set("n", "<leader>zt", "<Plug>(markdown-plus-table-transpose)", { buffer = true, desc = "Transpose table (swap rows/columns)" })
  vim.keymap.set("n", "<leader>zsa", "<Plug>(markdown-plus-table-sort-ascending)", { buffer = true, desc = "Sort table by column (ascending)" })
  vim.keymap.set("n", "<leader>zsd", "<Plug>(markdown-plus-table-sort-descending)", { buffer = true, desc = "Sort table by column (descending)" })
  vim.keymap.set("n", "<leader>zvx", "<Plug>(markdown-plus-table-to-csv)", { buffer = true, desc = "Convert table to CSV" })
  vim.keymap.set("n", "<leader>zvi", "<Plug>(markdown-plus-table-from-csv)", { buffer = true, desc = "Convert CSV to table" })

  -- Tables - Insert Mode Navigation with proper override options
  vim.keymap.set("i", "<C-Left>", "<Plug>(markdown-plus-table-nav-left)", { buffer = true, desc = "Move to cell on the left" })
  vim.keymap.set("i", "<C-Right>", "<Plug>(markdown-plus-table-nav-right)", { buffer = true, desc = "Move to cell on the right" })
  vim.keymap.set("i", "<C-Down>", "<Plug>(markdown-plus-table-nav-down)", { buffer = true, desc = "Move to cell below" })
  vim.keymap.set("i", "<C-Up>", "<Plug>(markdown-plus-table-nav-up)", { buffer = true, desc = "Move to cell above" })
end

-- Set up autocommand to create buffer-local keybinds for markdown, text, and txt files
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = {"*.md", "*.markdown", "*.txt", "*.text"},
  callback = setup_markdown_keybinds,
})

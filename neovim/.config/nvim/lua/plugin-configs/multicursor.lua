local mc = require("multicursor-nvim")

mc.setup()

local set = vim.keymap.set

-- Add all matches in the document

set({ "n", "v" }, "<leader>ct", mc.toggleCursor, { desc = "Toggle cursor" })
set({ "n", "v" }, "<leader>cc", mc.clearCursors, { desc = "Clear cursors" })
set({ "n", "v" }, "<leader>cT", function()
  if not mc.cursorsEnabled() then
    mc.enableCursors()
  elseif mc.hasCursors() then
    mc.disableCursors()
  end
end, { desc = "Toggle enabled" })
-- Rotate the main cursor.
set({ "n", "v" }, "<leader>cj", mc.nextCursor, { desc = "Next cursor" })
set({ "n", "v" }, "<leader>ck", mc.prevCursor, { desc = "Prev cursor" })

-- Delete the main cursor.
set({ "n", "v" }, "<leader>cd", mc.deleteCursor, { desc = "Delete cursor" })

-- Add and remove cursors with control + left click.
set("n", "<c-leftmouse>", mc.handleMouse, { desc = "Mouse cursor" })

-- Clone every cursor and disable the originals.
set({ "n", "v" }, "<leader>cD", mc.duplicateCursors, { desc = "Duplicate cursors" })

-- bring back cursors if you accidentally clear them
set("n", "<leader>cr", mc.restoreCursors)

-- Align cursor columns.
set("n", "<leader>ca", mc.alignCursors)

-- Append/insert for each line of visual selections.
set("v", "I", mc.insertVisual)
set("v", "A", mc.appendVisual)

-- Rotate visual selection contents.
set("v", "<leader>cl", function()
  mc.transposeCursors(1)
end)
set("v", "<leader>ch", function()
  mc.transposeCursors(-1)
end)

-- Jumplist support
set({ "v", "n" }, "<c-i>", mc.jumpForward)
set({ "v", "n" }, "<c-o>", mc.jumpBackward)

-- Customize how cursors look.
local hl = vim.api.nvim_set_hl
hl(0, "MultiCursorCursor", { link = "Cursor" })
hl(0, "MultiCursorVisual", { link = "Visual" })
hl(0, "MultiCursorSign", { link = "SignColumn" })
hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })

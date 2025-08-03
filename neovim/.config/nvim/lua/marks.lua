-- TODO: add snacks.picker to search only the trail marks
-- TODO: add option to delete marks from both trail and arrow feature?
-- Trailblazer replacement using last 10 global marks
local trail_marks = { "Z", "Y", "X", "W", "V", "U", "T", "S", "R", "Q" }
local mark_stack = {} -- stack of used marks
local current_index = 0 -- pointer to current mark in stack (0 = none selected)

-- Set a global mark at current cursor position
local function set_global_mark(mark)
  vim.cmd("normal! m" .. mark)
end

local function delete_global_mark(mark)
  vim.cmd.delmarks(mark)
end

local function jump_to_mark(mark)
  vim.cmd("normal! `" .. mark)
end

-- Add a trail mark
local function add_trail()
  local next_mark

  if #mark_stack < #trail_marks then
    next_mark = trail_marks[#mark_stack + 1]
    table.insert(mark_stack, next_mark)
  else
    next_mark = table.remove(mark_stack, 1)
    table.insert(mark_stack, next_mark)
  end

  set_global_mark(next_mark)
  current_index = #mark_stack -- move to newest mark
  print("Global mark set at " .. next_mark)
end

-- Remove the last mark in the stack
local function remove_trail()
  if #mark_stack == 0 then
    vim.notify("Trail stack is empty.", vim.log.levels.INFO)
    return
  end

  local last_mark = table.remove(mark_stack)
  delete_global_mark(last_mark)
  if current_index > #mark_stack then
    current_index = #mark_stack
  end
  vim.notify("Removed global mark " .. last_mark, vim.log.levels.INFO)
end

-- Go to previous mark (with wrap-around)
local function previous_mark()
  if #mark_stack == 0 then
    vim.notify("No trail marks to navigate.", vim.log.levels.INFO)
    return
  end

  current_index = current_index - 1
  if current_index < 1 then
    current_index = #mark_stack
  end
  jump_to_mark(mark_stack[current_index])

  print("Jumped to mark " .. mark_stack[current_index])
end

-- Go to next mark (with wrap-around)
local function next_mark()
  if #mark_stack == 0 then
    vim.notify("Trail stack is empty.", vim.log.levels.INFO)
    return
  end

  current_index = (current_index % #mark_stack) + 1
  jump_to_mark(mark_stack[current_index])
  print("Jumped to mark " .. mark_stack[current_index])
end

local function delete_global_marks()
  for _, mark in ipairs(trail_marks) do
    delete_global_mark(mark)
  end
end

local function list_trail_marks()
  local snacks = require("snacks")
  return snacks.picker.marks({
    transform = function(item)
      if item.label and item.label:match("^[Q-Z]$") and item then
        local original_label = item.label
        return item
      end
      return false
    end,
  })
end

local function clear_marks()
  delete_global_marks()
  mark_stack = {}
  current_index = 0
end

local function pop_mark()
  if #mark_stack == 0 then
    vim.notify("No trail marks left to navigate.", vim.log.levels.INFO)
    return
  end
  -- navigate to mark first
  local mark = mark_stack[current_index]
  jump_to_mark(mark)
  delete_global_mark(mark)
  table.remove(mark_stack, current_index)
  current_index = current_index - 1
end

delete_global_marks()

vim.keymap.set("n", "<c-s>", add_trail, { desc = "Set trail mark" })
vim.keymap.set("n", "<leader>mr", remove_trail, { desc = "Remove trail mark" })
vim.keymap.set("n", "<c-p>", pop_mark, { desc = "Pop trail mark" })
vim.keymap.set("n", "[m", previous_mark, { desc = "Previous trail mark" })
vim.keymap.set("n", "]m", next_mark, { desc = "Next trail mark" })
vim.keymap.set("n", "mt", list_trail_marks, { desc = "List trail marks" })

-- Annotation setup

local annotations = {}

-- local function add_annotation()
--   local lnum = vim.api.nvim_win_get_cursor(0)[1]
--   local bufnr = vim.api.nvim_get_current_buf()
--   local signlines = { {
--     type = "ann",
--     lnum = lnum,
--   } }
--   local mark = M.bookmark_line(lnum, bufnr)
--   vim.ui.input({ prompt = "Edit:", default = mark.a }, function(answer)
--     if answer == nil then
--       return
--     end
--     local line = api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1]
--     signs:remove(bufnr, lnum)
--     local text = config.keywords[string.sub(answer or "", 1, 2)]
--     if text then
--       signlines[1]["text"] = text
--     end
--     signs:add(bufnr, signlines)
--     updateBookmarks(bufnr, lnum, line, answer)
--   end)
-- end
--
-- add_annotation()

--[[
  Arrow replacement
  Uses m{1-9} to set marks in a file and then '{1-9} to jump to them

  Original idea from:
  https://github.com/neovim/neovim/discussions/33335
--]]

-- Convert a mark number (1-9) to its corresponding character (G-P)
local function delete_mark(mark)
  if string.match(mark, "[a-z]") then
    vim.api.nvim_buf_del_mark(0, mark)
  else
    vim.api.nvim_del_mark(mark)
  end
end

local function mark2char(mark)
  if mark:match("[1-9]") then
    local char = string.char(mark + 70)
    print(char)
    return char
  end
  return mark
end

local function char2mark(char)
  local mark = string.byte(char) - string.byte("G") + 1
  return mark
end

-- List bookmarks in the session
local function list_numbered_marks()
  local snacks = require("snacks")
  return snacks.picker.marks({
    transform = function(item)
      if item.label and item.label:match("^[G-P]$") and item then
        local original_label = item.label
        item.label = "" .. char2mark(original_label) .. ""
        item.text = string.gsub(item.text, "^.", char2mark(original_label))
        return item
      end
      return false
    end,
  })
end

-- Add Marks ------------------------------------------------------------------
vim.keymap.set("n", "m", function()
  local mark = vim.fn.getcharstr()
  local char = mark2char(mark)
  vim.cmd("mark " .. char)
  if mark:match("[1-9]") then
    vim.notify("Added mark " .. mark, vim.log.levels.INFO, { title = "Marks" })
  else
    vim.fn.feedkeys("m" .. mark, "n")
  end
end, { desc = "Add mark" })

-- Go To Marks ----------------------------------------------------------------
vim.keymap.set("n", "'", function()
  local mark = vim.fn.getcharstr()

  vim.fn.feedkeys("'" .. mark2char(mark), "n")
end, { desc = "Go to mark" })

-- List Marks -----------------------------------------------------------------
vim.keymap.set("n", "<c-n>", function()
  list_numbered_marks()
end, { desc = "List numbered marks" })

-- Delete Marks ---------------------------------------------------------------
vim.keymap.set("n", "dm", function()
  local mark = vim.fn.getcharstr()
  delete_mark(mark2char(mark))
  vim.notify("Deleted mark " .. mark, vim.log.levels.INFO, { title = "Marks" })
end, { desc = "Delete mark" })

vim.keymap.set("n", "<Leader>mD", function()
  vim.cmd("delmarks G-P")
  vim.notify("Deleted all marks", vim.log.levels.INFO, { title = "Marks" })
end, { desc = "Delete all marks" })

local trail_marks = { "Z", "Y", "X", "W", "V", "U", "T", "S", "R", "Q" }
local mark_stack = {} -- stack of used marks
local current_index = 0 -- pointer to current mark in stack (0 = none selected)

-- Set a global mark at current cursor position
local function set_global_mark(mark)
  vim.cmd("normal! m" .. mark)
end

-- Delete a mark from all buffers
local function delete_global_mark(mark)
  vim.cmd.delmarks(mark)
end

-- Jump to a global mark
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
    print("Trail mark stack is already empty.")
    return
  end

  local last_mark = table.remove(mark_stack)
  delete_global_mark(last_mark)
  if current_index > #mark_stack then
    current_index = #mark_stack
  end
  print("Removed global mark " .. last_mark)
end

-- Go to previous mark (with wrap-around)
local function previous_mark()
  if #mark_stack == 0 then
    print("No trail marks to navigate.")
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
    print("No trail marks to navigate.")
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

local function clear_marks()
  delete_global_marks()
  mark_stack = {}
  current_index = 0
end

local function pop_mark()
  if #mark_stack == 0 then
    print("No trail marks to navigate.")
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

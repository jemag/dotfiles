local toggleterm_manager = require("toggleterm-manager")

local term_actions = toggleterm_manager.actions
local actions_state = require("telescope.actions.state")
local actions = require("telescope.actions")

local function open_float(prompt_bufnr, exit_on_action)
  -- get current telescope selection
  local selection = actions_state.get_selected_entry()
  if selection == nil then
    return
  end

  -- get toggleterm's Terminal object
  local term = selection.value

  -- do something with the terminal
  term:toggle(80, "float")
end

local function custom_toggle(prompt_bufnr, exit_on_action)
  local current_picker = actions_state.get_current_picker(prompt_bufnr)

  local selection = actions_state.get_selected_entry()
  if selection == nil then
    return
  end

  local term = selection.value

  if exit_on_action then
    actions.close(prompt_bufnr)
    term:toggle()
    return
  end

  if term:is_open() then
    term:close()
  else
    term:open()
    current_picker.original_win_id = term.window
  end

end

toggleterm_manager.setup({
  mappings = {
    i = {
      ["<CR>"] = { action = term_actions.open_term, exit_on_action = true },
      -- toggles terminal open/closed
      ["<C-i>"] = { action = term_actions.create_and_name_term, exit_on_action = false },
      ["<C-y>"] = { action = term_actions.create_and_name_term, exit_on_action = false },
      ["<C-f>"] = { action = open_float, exit_on_action = false },
      -- deletes a terminal buffer
      ["<C-d>"] = { action = term_actions.delete_term, exit_on_action = false },
      -- provides a prompt to rename a terminal,
      ["<C-r>"] = { action = term_actions.rename_term, exit_on_action = false },
    },
  },
})

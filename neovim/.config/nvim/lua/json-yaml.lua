local utils = require("utils")

vim.api.nvim_create_user_command("YamlToJson", function()
  -- Get visual selection range
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")

  -- Get the selected text
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local text = table.concat(lines, "\n")

  -- Create a temporary file for the yaml content
  local tmp_file = vim.fn.tempname()
  local f = io.open(tmp_file, "w")

  if f ~= nil then
    f:write(text)
    f:close()
  else
    print("Error: Could not create temporary file")
    return
  end

  -- Convert using yq and capture the output
  local out = vim.system({
    "yq",
    "-P",
    "-o=json",
    tmp_file,
  }, { text = true }):wait()

  if out.code ~= 0 then
    print("response.code=" .. out.code)
    print("response.stderr=" .. out.stderr)
    return
  end

  local json = out.stdout

  -- Delete temp file
  os.remove(tmp_file)

  local buf = utils.create_temp_vertical_split()
  vim.api.nvim_set_option_value("filetype", "json", { buf = buf })

  -- Set the converted JSON in the new buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(json, "\n"))
end, { range = true })

vim.api.nvim_create_user_command("JsonToYaml", function()
  -- Get visual selection range
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")

  -- Get the selected text
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local text = table.concat(lines, "\n")

  -- Create a temporary file for the json content
  local tmp_file = vim.fn.tempname()
  local f = io.open(tmp_file, "w")

  if f ~= nil then
    f:write(text)
    f:close()
  else
    print("Error: Could not create temporary file")
    return
  end

  -- Convert using yq and capture the output
  local out = vim.system({
    "yq",
    "-P",
    "-o=yaml",
    tmp_file,
  }, { text = true }):wait()


  if out.code ~= 0 then
    print("response.code=" .. out.code)
    print("response.stderr=" .. out.stderr)
    return
  end

  local yaml = out.stdout

  -- Delete temp file
  os.remove(tmp_file)

  local buf = utils.create_temp_vertical_split()
  vim.api.nvim_set_option_value("filetype", "yaml", { buf = buf })

  -- Set the converted JSON in the new buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(yaml, "\n"))
end, { range = true })

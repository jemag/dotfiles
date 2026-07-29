local resession = require("resession")
resession.setup({
  buf_filter = function(bufnr)
    local buftype = vim.bo[bufnr].buftype
    if buftype == "help" then
      return true
    end
    if buftype ~= "" and buftype ~= "acwrite" then
      return false
    end
    if vim.api.nvim_buf_get_name(bufnr) == "" then
      return false
    end

    -- this is required, since the default filter skips nobuflisted buffers
    return true
  end,
  extensions = { scope = {} }, -- add scope.nvim extension
})

local M = {}

-- Name of the current project, derived from the cwd basename
function M.project_name()
  return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
end

function M.quick_save()
  local name = M.project_name()
  resession.save(name, { notify = false })
  vim.notify("Session saved: " .. name)
end

function M.quick_load()
  local name = M.project_name()
  local ok = pcall(resession.load, name, { silence_errors = false })
  if not ok then
    vim.notify("No session for project: " .. name, vim.log.levels.WARN)
  end
end

return M

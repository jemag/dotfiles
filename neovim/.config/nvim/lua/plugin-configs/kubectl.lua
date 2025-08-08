require("kubectl").setup({
  auto_refresh = {
    enabled = true,
    interval = 300, -- milliseconds
  },
  diff = {
    bin = "kubediff", -- or any other binary
  },
  namespace = "All",
  hints = true,
  context = true,
  logs = {
    prefix = false,
    timestamps = true,
    since = "24h",
  },
  float_size = {
    -- Almost fullscreen:
    -- width = 1.0,
    -- height = 0.95, -- Setting it to 1 will cause bottom to be cutoff by statuscolumn

    -- For more context aware size:
    width = 0.9,
    height = 0.85,

    -- Might need to tweak these to get it centered when float is smaller
    col = 5,
    row = 5,
  },
  obj_fresh = 0, -- highlight if creation newer than number (in minutes)
})
local group = vim.api.nvim_create_augroup("kubectl_custom_mappings", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "k8s_*",
  callback = function(ev)
    local k = vim.keymap.set
    local opts = { buffer = ev.buf }
    vim.wo.relativenumber = true
    -- Global
    -- k("n", "<localleader>th", "<Plug>(kubectl.toggle_headers) | <Plug>(kubectl.refresh)", opts) -- Toggle headers
    k("n", "<localleader>th", "<Plug>(kubectl.toggle_headers)", opts) -- Toggle headers
    k("i", "<c-n>", "<Plug>(kubectl.tab)", opts) -- Toggle headers
    k("i", "<c-p>", "<Plug>(kubectl.shift_tab)", opts) -- Toggle headers
    vim.defer_fn(function()
      for i = 1, 6 do
        pcall(vim.keymap.del, "n", tostring(i), opts)
      end
    end, 100)
  end,
})

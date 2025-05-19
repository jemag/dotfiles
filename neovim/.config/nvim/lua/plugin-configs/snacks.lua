local filter_windows = require("utils").filter_windows
local isNotWSL = vim.fn.getenv("WSL_INTEROP") == vim.NIL

local snacks = require("snacks")
snacks.setup({
  styles = {
    notification_history = {
      relative = "editor",
      border = "rounded",
      zindex = 100,
      width = 0.95,
      height = 0.95,
      minimal = false,
      title = " Notification History ",
      title_pos = "center",
      ft = "markdown",
      bo = { filetype = "snacks_notif_history", modifiable = false },
      wo = { wrap = true, winhighlight = "Normal:SnacksNotifierHistory" },
      keys = { q = "close" },
    },
    notification = {
      relative = "editor",
      wo = {
        wrap = true,
      },
    },
  },
  bigfile = {
    enabled = true,
    size = 0.5 * 1024 * 1024, -- 0.5 MiB
  },
  image = {
    enabled = isNotWSL,
    doc = {
      enabled = true,
      inline = false,
    },
  },
  notifier = {
    enabled = true,
  },
  quickfile = {
    enabled = true,
  },
  statuscolumn = {
    enabled = false,
    left = { "mark"}, -- priority of signs on the left (high to low)
    right = {},
  },
  scratch = {
    ft = function()
      return "markdown"
    end,
  },
  words = {
    enabled = true,
  },
  picker = {
    sources = {
      explorer = {
        finder = "explorer",
        sort = { fields = { "sort" } },
        tree = true,
        supports_live = true,
        follow_file = true,
        focus = "list",
        auto_close = false,
        jump = { close = false },
        layout = { preset = "sidebar", preview = false },
        formatters = { file = { filename_only = true } },
        matcher = { sort_empty = true },
        config = function(opts)
          return require("snacks.picker.source.explorer").setup(opts)
        end,
        win = {
          list = {
            keys = {
              ["<BS>"] = "explorer_up",
              ["a"] = "explorer_add",
              ["d"] = "explorer_del",
              ["r"] = "explorer_rename",
              ["c"] = "explorer_copy",
              ["m"] = "explorer_move",
              ["y"] = "explorer_yank",
              ["<c-c>"] = "explorer_cd",
              ["."] = "explorer_focus",
            },
          },
        },
      },
    },
    formatters = {
      file = {
        truncate = 80,
      },
    },
    actions = {
      pick_win_updated = function(picker, item)
        picker.layout:hide()
        local win = snacks.picker.util.pick_win({ main = picker.main, filter = filter_windows })

        if not win then
          picker.layout:unhide()
          return true
        end
        picker.main = win
        vim.defer_fn(function()
          if not picker.closed then
            picker.layout:unhide()
          end
        end, 100)
      end,
    },
    enabled = true,
    win = {
      input = {
        keys = {
          ["<Esc>"] = { "close", mode = { "n", "i" } },
          ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
          ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
          ["<c-f>"] = { "list_scroll_down", mode = { "i", "n" } },
          ["<c-b>"] = { "list_scroll_up", mode = { "i", "n" } },
          ["<c-v>"] = { { "pick_win_updated", "edit_vsplit" }, mode = { "i", "n" } },
          ["<c-s>"] = { { "pick_win_updated", "edit_split" }, mode = { "i", "n" } },
          ["<c-e>"] = { { "pick_win_updated", "edit" }, mode = { "i", "n" } },
          ["<c-t>"] = { "edit_tab", mode = { "i", "n" } },
        },
      },
      list = {
        keys = {
          ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
          ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
        },
      },
    },
  },
})

vim.keymap.set("n", "<localleader>ts", function()
  snacks.scratch()
end, { desc = "Toggle scratch buffer" })
vim.keymap.set("n", "<localleader>tS", function()
  snacks.scratch.select()
end, { desc = "Select scratch buffer" })
vim.keymap.set("n", "<localleader>tS", function()
  snacks.scratch.select()
end, { desc = "Select scratch buffer" })
vim.keymap.set("n", "<localleader>tN", snacks.notifier.hide, { desc = "Hide notifications" })
vim.keymap.set("n", "<localleader>th", snacks.notifier.show_history, { desc = "Notifications history" })
vim.keymap.set({ "n", "x", "t" }, "]w", function()
  snacks.words.jump(vim.v.count1)
end, { desc = "Jump to next word reference" })
vim.keymap.set({ "n", "x", "t" }, "[w", function()
  snacks.words.jump(-vim.v.count1)
end, { desc = "Jump to prev word reference" })

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  pattern = "*",
  command = "highlight! link SnacksPickerDir Conceal",
  desc = "Link SnacksPickerDir to Conceal",
})

-- profile mappings
vim.keymap.set("n", "<localleader>tp", snacks.profiler.toggle, { desc = "Toggle profiler" })
-- picker mappings
vim.keymap.set("n", "<leader>s/", snacks.picker.lines, { desc = "Find in buffer" })
vim.keymap.set("n", "<leader>s;", snacks.picker.commands, { desc = "Commands" })
vim.keymap.set("n", "<leader>sb", snacks.picker.buffers, { desc = "Open buffers" })
vim.keymap.set("n", "<leader>sB", function()
  snacks.picker()
end, { desc = "Pickers all" })
vim.keymap.set("n", "<leader>sgB", snacks.picker.git_log_file, { desc = "Buffer commits" })
vim.keymap.set("n", "<leader>sgc", snacks.picker.git_log, { desc = "Commits" })
vim.keymap.set("n", "<leader>sgd", snacks.picker.git_diff, { desc = "Diff" })
vim.keymap.set("n", "<leader>sgs", snacks.picker.git_status, { desc = "Git status" })
vim.keymap.set("n", "<leader>sl", snacks.picker.loclist, { desc = "Loclist" })
vim.keymap.set("n", "<leader>sm", snacks.picker.man, { desc = "Man" })

vim.keymap.set("n", "<leader>sE", function()
  vim.api.nvim_command("doautocmd User LoadColorSchemes")
  snacks.picker.colorschemes()
end, { desc = "Colorschemes" })
vim.keymap.set("n", "<leader>sh", snacks.picker.command_history, { desc = "Fuzzy Command History" })
vim.keymap.set("n", "<leader>sH", snacks.picker.highlights, { desc = "Fuzzy Highlights" })
vim.keymap.set("n", "<leader>sk", snacks.picker.keymaps, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>sf", function()
  snacks.picker.files({ hidden = true })
end, { desc = "Files" })
vim.keymap.set("n", "<leader>st", function()
  snacks.picker.grep({ hidden = true })
end, { desc = "Grep" })
vim.keymap.set("n", "<leader>sp", snacks.picker.help, { desc = "Help" })
vim.keymap.set("n", "<leader>sP", snacks.picker.projects, { desc = "Projects" })
vim.keymap.set("n", "<leader>sq", snacks.picker.qflist, { desc = "Quickfix" })
vim.keymap.set("n", "<leader>ss", snacks.picker.lsp_symbols, { desc = "LSP Symbols" })
vim.keymap.set("n", "<leader>sS", snacks.picker.lsp_workspace_symbols, { desc = "LSP Workspace Symbols" })
vim.keymap.set("n", "<leader>su", snacks.picker.undo, { desc = "Undo" })
vim.keymap.set("n", "<leader>s.", snacks.picker.resume, { desc = "Resume" })
vim.keymap.set("n", "<leader>se", snacks.picker.icons, { desc = "Emoji" })
vim.keymap.set("n", "<leader>sF", function()
  snacks.picker.files({ hidden = true, ignored = true })
end, { desc = "Files include ignored" })
vim.keymap.set("n", "<leader>sT", function()
  snacks.picker.grep({ hidden = true, ignored = true })
end, { desc = "Grep include ignored" })
vim.keymap.set("n", "<leader>sd", function()
  snacks.picker.files({ hidden = true, ignored = true, cwd = vim.fn.expand("%:p:h") })
end, { desc = "Files current directory" })
vim.keymap.set("n", "<leader>sz", function()
  snacks.picker.files({ hidden = true, ignored = false, cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") })
end, { desc = "Files current directory" })
vim.keymap.set("n", "<leader>sx", function()
  vim.ui.input({ prompt = "Files in dir: " }, function(input)
    snacks.picker.files({ hidden = true, ignored = true, cwd = input })
  end)
end, { desc = "Files based on input dir" })
vim.keymap.set("n", "<leader>sX", function()
  vim.ui.input({ prompt = "Grep in dir: " }, function(input)
    snacks.picker.grep({ hidden = true, ignored = true, cwd = input })
  end)
end, { desc = "Grep based on input dir" })

vim.keymap.set("n", "<leader>sD", function()
  snacks.picker.grep({ hidden = true, ignored = true, cwd = vim.fn.expand("%:p:h") })
end, { desc = "Files current directory" })
vim.keymap.set("n", "<leader>sw", snacks.picker.grep_word, { desc = "Grep word" })

local function switch_window()
  local window = snacks.picker.util.pick_win({ filter = filter_windows })
  if window ~= nil then
    vim.api.nvim_set_current_win(window)
  end
end
local function close_window()
  local window = snacks.picker.util.pick_win({ filter = filter_windows })
  if window ~= nil then
    vim.api.nvim_win_close(window, false)
  end
end
local function swap_window()
  local picked_window = snacks.picker.util.pick_win({ filter = filter_windows })
  if picked_window ~= nil then
    local picked_buffer = vim.api.nvim_win_get_buf(picked_window)
    local current_buffer = vim.api.nvim_get_current_buf()
    local current_window = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(picked_window, current_buffer)
    vim.api.nvim_win_set_buf(current_window, picked_buffer)
  end
end

vim.keymap.set("n", "<c-w>S", swap_window, { desc = "Swap window by id" })
vim.keymap.set("n", "<c-w>m", switch_window, { desc = "Move to window by id" })
vim.keymap.set("n", "<c-w>Q", close_window, { desc = "Close window by id" })

-- Since we cannot use smart-splits wrapping navigation in a floating window
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "snacks_picker_list",
  callback = function()
    vim.keymap.set("n", "<c-l>", "<c-w><c-l>", { buffer = 0, desc = "navigate right window" })
    vim.keymap.set("n", "<c-h>", "<c-w><c-h>", { buffer = 0, desc = "navigate left window" })
  end,
  desc = "Snacks picker list floating window navigate away",
})

--          ╭─────────────────────────────────────────────────────────╮
--          │                     customer pickers                    │
--          ╰─────────────────────────────────────────────────────────╯
local function get_directories()
  local directories = {}

  local handle = io.popen("fd --type directory --full-path '.'")
  if handle then
    for line in handle:lines() do
      table.insert(directories, { text = line, file = line })
    end
    handle:close()
  else
    print("Failed to execute fd command")
  end

  return directories
end

vim.keymap.set("n", "<leader>si", function()
  local Snacks = require("snacks")
  local dirs = get_directories()

  return Snacks.picker({
    items = dirs,
    confirm = function(picker, item)
      picker:close()
      Snacks.picker.pick("files", {
        dirs = { item.file },
      })
    end,
  })
end, { desc = "Search files in directory" })

vim.keymap.set("n", "<leader>sI", function()
  local Snacks = require("snacks")
  local dirs = get_directories()

  return Snacks.picker({
    items = dirs,
    confirm = function(picker, item)
      picker:close()
      Snacks.picker.pick("grep", {
        dirs = { item.file },
      })
    end,
  })
end, { desc = "Search text in directory" })

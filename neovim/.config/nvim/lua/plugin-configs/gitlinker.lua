require("gitlinker").setup({
  -- print message in command line
  message = true,

  -- highlights the linked line(s) by the time in ms
  -- disable highlight by setting a value equal or less than 0
  highlight_duration = 500,

  -- user command
  command = {
    -- to copy link to clipboard, use: 'GitLink'
    -- to open link in browser, use bang: 'GitLink!'
    -- to use blame router, use: 'GitLink blame'
    -- to use browse router, use: 'GitLink browse' (which is the default router)
    name = "GitLink",
    desc = "Generate git permanent link",
  },

  -- router
  router = {
    browse = {
      ["^github%.com"] = require("gitlinker.routers").github_browse,
      ["^gitlab%.com"] = require("gitlinker.routers").gitlab_browse,
      ["^bitbucket%.org"] = require("gitlinker.routers").bitbucket_browse,
      ["^dev.azure%.com"] = "https://dev.azure.com/"
        .. "{_A.USER}/"
        .. "{_A.REPO}"
        .. "?path=/{_A.FILE}"
        .. "&version={_A.REV}"
        .. "&Line={_A.LSTART}"
        .. "{(_A.LEND > _A.LSTART and ('&LineEnd=' .. _A.LEND) or '')}"
        .. "&lineStyle=plain"
        .. "&_a=contents"
    },
    -- https://dev.azure.com/foc-poc/AKS/_git/SystemInformer?path=/Dockerfile&version=GC3c76fa9e8a3add2f6d9683a7df1c1f9ae4295fbf&line=14&lineEnd=16&lineStartColumn=1&lineEndColumn=74&lineStyle=plain&_a=contents
    blame = {
      ["^github%.com"] = require("gitlinker.routers").github_blame,
      ["^gitlab%.com"] = require("gitlinker.routers").gitlab_blame,
      ["^bitbucket%.org"] = require("gitlinker.routers").bitbucket_blame,
    },
  },

  -- enable debug
  debug = false,

  -- write logs to console(command line)
  console_log = true,

  -- write logs to file
  file_log = false,
})
-- browse
vim.keymap.set({ "n", "x" }, "<leader>gly", "<cmd>GitLink<cr>", { silent = true, noremap = true, desc = "Copy git permlink to clipboard" })
vim.keymap.set({ "n", "x" }, "<leader>glg", "<cmd>GitLink!<cr>", { silent = true, noremap = true, desc = "Open git permlink in browser" })
-- blame
vim.keymap.set(
  { "n", "x" },
  "<leader>glb",
  "<cmd>GitLink blame<cr>",
  { silent = true, noremap = true, desc = "Copy git blame link to clipboard" }
)
vim.keymap.set(
  { "n", "x" },
  "<leader>glB",
  "<cmd>GitLink! blame<cr>",
  { silent = true, noremap = true, desc = "Open git blame link in browser" }
)

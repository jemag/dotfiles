require("which-key").setup({})
local wk = require("which-key")
wk.setup({
  preset = "modern",
})
wk.add({
  {
    -- Nested mappings are allowed and can be added in any order
    -- Most attributes can be inherited or overridden on any level
    -- There's no limit to the depth of nesting
    mode = { "n", "v" }, -- NORMAL and VISUAL mode
    { "<leader>b", group = "+buffer" },
    { "<leader>d", group = "+debug" },
    { "<leader>ds", group = "+step" },
    { "<leader>dt", group = "+telescope" },
    { "<leader>f", group = "+format" },
    { "<leader>g", group = "+git" },
    { "<leader>gh", group = "+git history" },
    { "<leader>gl", group = "+git linker" },
    { "<leader>gm", group = "+git merge" },
    { "<leader>h", group = "+hunk" },
    { "<leader>i", group = "+insert" },
    { "<leader>ib", group = "+comment box" },
    { "<leader>k", group = "+kubernetes" },
    { "<leader>l", group = "+language" },
    { "<leader>m", group = "+bookmarks" },
    { "<leader>n", group = "+neotest" },
    { "<leader>nr", group = "+neotest run" },
    { "<leader>o", group = "+obsidian" },
    { "<leader>r", group = "+refactor" },
    { "<leader>s", group = "+search" },
    { "<leader>sg", group = "+git" },
    { "<leader>t", group = "+terminal" },
    { "<leader>u", group = "+unique" },
    { "<leader>w", group = "+window" },
    { "<localleader>m", group = "+misc" },
    { "<localleader>ms", group = "+schema" },
    { "<localleader>mp", group = "+paste image" },
    { "<localleader>p", group = "+project" },
    { "<localleader>ps", group = "+session" },
    { "<localleader>s", group = "+misc search" },
    { "<localleader>t", group = "+toggle" },
    { "<localleader>tm", group = "+markdown" },
  },
})

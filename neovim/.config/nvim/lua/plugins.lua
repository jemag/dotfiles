-- bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "tyru/capture.vim",
    cmd = "Capture",
    keys = {
      {
        "<localleader>tM",
        "<cmd>Capture messages<cr>",
        noremap = true,
        silent = true,
        desc = "Capture messages",
      },
    },
  },
  {
    "NStefan002/screenkey.nvim",
    cmd = "Screenkey",
    lazy = true,
    version = "*", -- or branch = "main", to use the latest commit
  },
  --[[ #######################
     General
    ####################### ]]
  {
    "kevinhwang91/nvim-bqf",
    config = function()
      require("plugin-configs.bqf")
    end,
  },
  {
    "stevearc/quicker.nvim",
    event = "FileType qf",
    opts = {
      highlight = {
        load_buffers = false,
      },
    },
  },
  -- Scope buffers to their specific tab
  {
    "tiagovla/scope.nvim",
    config = function()
      require("scope").setup()
    end,
  },
  { "serhez/bento.nvim", opts = {} },
  {
    "smjonas/live-command.nvim",
    config = function()
      require("plugin-configs.live-command")
    end,
  },
  {
    "tzachar/highlight-undo.nvim",
    config = function()
      require("plugin-configs.highlight-undo")
    end,
  },
  {
    "ramilito/kubectl.nvim",
    config = function()
      require("plugin-configs.kubectl")
    end,
    version = "*",
    dependencies = "saghen/blink.download",
    lazy = true,
    keys = {
      {
        "<leader>kt",
        '<cmd>lua require("kubectl").toggle({tab = true})<cr>',
        noremap = true,
        silent = true,
        desc = "Toggle kubectl.nvim",
      },
      -- { 'go', '<Plug>(kubectl.view_overview)', ft = 'k8s_*' },
    },
  },
  {
    "Allaman/tf.nvim",
    opts = {},
    ft = {"terraform", "tf", "tfvars", "hcl" },
    keys = {
      { "<localleader>dt", "<cmd>TerraformDocOpen<cr>", desc = "Open terraform docs" },
    },
  },
  {
    "Allaman/kustomize.nvim",
    lazy = true,
    config = function()
      require("plugin-configs.kustomize")
    end,
    keys = {
      { "<leader>kb", "<cmd>KustomizeBuild<cr>", desc = "kustomize build" },
      { "<leader>kk", "<cmd>KustomizeListKinds<cr>", desc = "kustomize kinds" },
      { "<leader>kl", "<cmd>KustomizeListResources<cr>", desc = "kustomize list resources" },
      { "<leader>kp", "<cmd>KustomizePrintResources<cr>", desc = "kustomize print resources" },
      { "<leader>kv", "<cmd>KustomizeValidate<cr>", desc = "kustomize validate" },
      { "<leader>kd", "<cmd>KustomizeDeprecations<cr>", desc = "kustomize deprecations" },
    },
  },
  {
    -- "someone-stole-my-name/yaml-companion.nvim",
    "astephanh/yaml-companion.nvim",
    branch = "kubernetes_crd_detection",
    lazy = true,
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      require("plugin-configs.yaml-companion")
    end,
    ft = { "yaml", "json" },
  },
  {
    "AckslD/nvim-trevJ.lua",
    config = function()
      require("plugin-configs.nvim-trevJ")
    end,
  },
  {
    "mrjones2014/smart-splits.nvim",
    config = function()
      require("plugin-configs.smart-splits")
    end,
  },
  {
    "folke/noice.nvim",
    config = function()
      require("plugin-configs.noice")
    end,
  },
  {
    "phelipetls/jsonpath.nvim",
    ft = { "json" },
  },
  {
    "jemag/nvim-jsonnet",
    lazy = true,
    ft = "jsonnet",
    branch = "local-setup",
    config = function()
      require("plugin-configs.nvim-jsonnet")
    end,
  },
  {
    "svban/YankAssassin.nvim",
    config = function()
      require("YankAssassin").setup({
        auto_normal = true, -- if true, autocmds are used. Whenever y is used in normal mode, the cursor doesn't move to start
        auto_visual = true, -- if true, autocmds are used. Whenever y is used in visual mode, the cursor doesn't move to start
      })
    end,
  },
  {
    "danymat/neogen",
    config = function()
      require("neogen").setup({
        enabled = true,
        snippet_engine = "luasnip",
      })
    end,
    lazy = true,
    keys = {
      { "<leader>in", "<cmd>Neogen<cr>", mode = { "n", "x" }, desc = "Neogen" },
    },
    dependencies = {
      { "nvim-treesitter/nvim-treesitter" },
      { "L3MON4D3/LuaSnip" },
    },
  },
  {
    "haya14busa/vim-asterisk",
    config = function()
      require("plugin-configs.vim-asterisk")
    end,
  },
  {
    "MagicDuck/grug-far.nvim",
    config = function()
      require("plugin-configs.grugfar")
    end,
    lazy = true,
    keys = {
      { "<leader>rg", "<cmd>GrugFar<CR>", desc = " GrugFar" },
    },
  },
  {
    "ethanholz/nvim-lastplace",
    config = function()
      require("plugin-configs.nvim-lastplace")
    end,
  },
  {
    "folke/todo-comments.nvim",
    lazy = false,
    config = function()
      require("plugin-configs.todo-comments")
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1300,
    lazy = false,
    config = function()
      require("plugin-configs.snacks")
    end,
  },
  {
    "folke/trouble.nvim",
    event = "VeryLazy",
    config = function()
      require("plugin-configs.trouble")
    end,
  },
  {
    "woosaaahh/sj.nvim",
    event = "VeryLazy",
    config = function()
      require("plugin-configs.sj")
    end,
  },
  {
    "akinsho/bufferline.nvim",
    lazy = false,
    config = function()
      require("plugin-configs.bufferline")
    end,
  },
  {
    "A7Lavinraj/fyler.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugin-configs.fyler")
    end,
  },
  {
    -- "tomasky/bookmarks.nvim",
    -- "ten3roberts/bookmarks.nvim",
    "jemag/bookmarks.nvim",
    lazy = true,
    -- branch = "feat-scoped-bookmarks",
    config = function()
      require("plugin-configs.bookmarks")
    end,
  },
  {
    "dstein64/nvim-scrollview",
    event = "VeryLazy",
    config = function()
      require("plugin-configs.scrollview")
    end,
  },
  {
    "hat0uma/csvview.nvim",
    config = function()
      require("plugin-configs.csvview")
    end,
    lazy = true,
    ft = { "csv" },
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
    keys = {
      { "<localleader>tC", "<cmd>CsvViewToggle<cr>", desc = "Toggle CSV View" },
    },
  },
  {
    event = "VeryLazy",
    "akinsho/toggleterm.nvim",
    config = function()
      require("plugin-configs.toggleterm")
    end,
  },
  {
    "obsidian-nvim/obsidian.nvim",
    config = function()
      require("plugin-configs.obsidian")
    end,
    version = "*",
    enabled = vim.fn.getenv("OBSIDIAN_VAULT") ~= vim.NIL,
    lazy = true,
    ft = "markdown",
    keys = require("keybindings.lazy-keybinds").obsidian,
  },
  {
    "jake-stewart/multicursor.nvim",
    event = "VeryLazy",
    config = function()
      require("plugin-configs.multicursor")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      vim.cmd([[TSUpdate]])
    end,
    config = function()
      require("plugin-configs.nvim-treesitter")
    end,
    branch = "main",
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    config = function()
      require("plugin-configs.nvim-treesitter-textobjects")
    end,
    branch = "main",
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "VeryLazy",
    config = function()
      require("plugin-configs.rainbow-delimiters")
    end,
  },
  {
    "Isrothy/lualine-diagnostic-message",
    event = "VeryLazy",
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      require("plugin-configs.lualine")
    end,
  },
  { "tweekmonster/startuptime.vim" },
  {
    "nvim-neotest/neotest",
    config = function()
      require("plugin-configs.neotest")
    end,
    lazy = true,
    keys = require("keybindings.lazy-keybinds").neotest,
    dependencies = {
      "sidlatau/neotest-dart",
      "Issafalcon/neotest-dotnet",
      "jfpedroza/neotest-elixir",
      "nvim-neotest/neotest-go",
      "nvim-neotest/nvim-nio",
      "rcasia/neotest-java",
      "nvim-neotest/neotest-jest",
      "olimorris/neotest-phpunit",
      "nvim-neotest/neotest-python",
      "rouge8/neotest-rust",
      "lawrence-laz/neotest-zig",
    },
  },
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    config = function()
      require("plugin-configs.dap")
    end,
  },
  {
    "brianhuster/live-preview.nvim",
    config = function()
      require("livepreview.config").set({
        picker = "vim.ui.select",
      })
    end,
    lazy = true,
    cmd = { "LivePreview" },
    keys = {
      { "<localleader>tmp", "<cmd>LivePreview start<cr>", desc = "Preview markdown" },
      { "<localleader>tmP", "<cmd>LivePreview close<cr>", desc = "Stop markdown preview" },
    },
    dependencies = {
      "folke/snacks.nvim",
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
    config = function()
      require("plugin-configs.render-markdown")
    end,
    lazy = true,
    ft = { "markdown", "rmd" },
  },
  {
    "jbyuki/one-small-step-for-vimkind",
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    config = function()
      require("plugin-configs.nvim-dap-ui")
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    event = "VeryLazy",
    config = function()
      require("plugin-configs.nvim-dap-virtual-text")
    end,
  },
  { "mfussenegger/nvim-jdtls", lazy = true, ft = { "java" } },
  { "lambdalisue/suda.vim", event = "VeryLazy" },

  -- Themes
  {
    "loctvl842/monokai-pro.nvim",
    event = "User LoadColorSchemes",
    config = function()
      require("monokai-pro").setup({
        terminal_colors = false,
        background_clear = {
          "floaterm",
          "neo-tree",
          "bufferline",
        },
      })
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    event = "User LoadColorSchemes",
    config = function()
      require("kanagawa").setup({
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = "none",
              },
            },
          },
        },
      })
    end,
  },
  {
    "serhez/teide.nvim",
    event = "User LoadColorSchemes",
  },
  {
    "EdenEast/nightfox.nvim",
    event = "User LoadColorSchemes",
  },
  {
    "Shatur95/neovim-ayu",
    priority = 1000,
    config = function()
      require("ayu").setup({
        overrides = function()
          local c = require("ayu.colors")
          return {
            RenderMarkdownCode = { bg = c.selection_inactive },
            RenderMarkdownCodeBorder = { bg = c.selection_bg },
            RenderMarkdownCodeInline = { fg = c.tag, bg = c.selection_inactive },
            ["@markup.heading"] = { fg = c.keyword, bold = true },
            ["@markup.strong"] = { fg = c.keyword, bold = true },
            ["@markup.italic"] = { fg = c.keyword, italic = true },
            ["@markup.list"] = { fg = c.vcs_added },
            ["@markup.raw"] = { fg = c.tag, bg = c.selection_inactive },
            ["@markup.quote"] = { fg = c.constant, italic = true },
          }
        end,
      })
    end,
  },
  {
    "habamax/vim-gruvbit",
    event = "User LoadColorSchemes",
  },

  --[[ #######################
     Interface
    ####################### ]]
  { "nvim-tree/nvim-web-devicons", event = "VeryLazy" },
  {
    "uga-rosa/ccc.nvim",
    config = function()
      require("ccc").setup()
    end,
    lazy = true,
    cmd = { "CccConvert", "CccPick", "CccHighlighterToggle" },
    keys = {
      { "<localleader>to", "<cmd>CccHighlighterToggle<cr>", desc = "Toggle colorizer" },
    },
  },
  {
    event = "VeryLazy",
    "jedrzejboczar/possession.nvim",
    config = function()
      require("plugin-configs.possession")
    end,
  },
  {
    "junegunn/vim-easy-align",
    lazy = true,
    keys = {
      { "<leader>fe", "<Plug>(EasyAlign)", desc = "Easy align" },
    },
  },
  {
    "mbbill/undotree",
    lazy = true,
    config = function()
      require("plugin-configs.undotree")
    end,
    keys = {
      { "<localleader>tu", "<cmd>UndotreeToggle<cr>", desc = "Undotree" },
    },
  },

  { "tpope/vim-repeat" },
  --[[ #######################
     Search Plugins
    ####################### ]]
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    config = function()
      require("plugin-configs.img-clip")
    end,
  },

  --[[ #######################
     Database
    ####################### ]]
  -- TODO: Check if still needed
  {
    "tpope/vim-dadbod",
    cmd = "DB",
    lazy = true,
  },
  --[[ #######################
     Git
    ####################### ]]
  {
    "aaronhallaert/advanced-git-search.nvim",
    branch = "bugfix/snacks_required_cmd",
    config = function()
      require("plugin-configs.advanced-git-search")
    end,
    dependencies = {
      "folke/snacks.nvim",
    },
  },
  {
    "esmuellert/codediff.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("plugin-configs.codediff")
    end,
    lazy = true,
    keys = {
      { "<leader>gdv", "<cmd>CodeDiff<cr>", desc = "CodeDiff" },
      { "<leader>gdV", ":CodeDiff ", desc = "CodeDiff custom" },
    },
  },
  {
    "sindrets/diffview.nvim",
    config = function()
      require("plugin-configs.diffview")
    end,
    event = "VeryLazy",
  },
  {
    "bkoropoff/clipipe",
    event = "VeryLazy",
    config = function()
      require("plugin-configs.clipipe")
    end,
    enabled = vim.fn.getenv("WSL_INTEROP") ~= vim.NIL,
  },
  {
    "wintermute-cell/gitignore.nvim",
    cmd = "GitIgnore",
    lazy = true,
  },
  {
    "akinsho/git-conflict.nvim",
    event = "VeryLazy",
    config = function()
      require("plugin-configs.git-conflict")
    end,
  },
  {
    "pwntester/octo.nvim",
    config = function()
      require("plugin-configs.octo")
    end,
    lazy = true,
    cmd = "Octo",
    keys = {
      { "<leader>go", "<cmd>Octo actions<cr>", desc = "Octo action" },
    },
  },
  {
    "linrongbin16/gitlinker.nvim",
    config = function()
      require("plugin-configs.gitlinker")
    end,
    lazy = true,
    keys = {
      {
        mode = { "n", "x" },
        "<leader>gly",
        "<cmd>GitLink<cr>",
        silent = true,
        noremap = true,
        desc = "Copy git permlink to clipboard",
      },
      {
        mode = { "n", "x" },
        "<leader>glg",
        "<cmd>GitLink!<cr>",
        silent = true,
        noremap = true,
        desc = "Open git permlink in browser",
      },
      -- blame
      {
        mode = { "n", "x" },
        "<leader>glb",
        "<cmd>GitLink blame<cr>",
        silent = true,
        noremap = true,
        desc = "Copy git blame link to clipboard",
      },
      {
        mode = { "n", "x" },
        "<leader>glB",
        "<cmd>GitLink! blame<cr>",
        silent = true,
        noremap = true,
        desc = "Open git blame link in browser",
      },
    },
  },
  {
    "NeogitOrg/neogit",
    config = function()
      require("plugin-configs.neogit")
    end,
    lazy = true,
    keys = {
      {
        "<localleader>tn",
        "<cmd>Neogit<cr>",
        desc = "Neogit",
      },
      {
        "<leader>gc",
        "<cmd>Neogit commit<cr>",
        desc = "Neogit commit",
      },
      {
        "<leader>gP",
        "<cmd>Neogit push<cr>",
        desc = "Neogit push",
      },
      {
        "<leader>gp",
        "<cmd>Neogit pull<cr>",
        desc = "Neogit pull",
      },
    },
  },
  {
    "afonsofrancof/worktrees.nvim",
    event = "VeryLazy",
    config = function()
      require("plugin-configs.worktree")
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    config = function()
      require("plugin-configs.gitsigns")
    end,
  },

  --[[ #######################
     Language
    ####################### ]]
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lsp")
    end,
  },
  -- TODO: replace with something not deprecated
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    config = function()
      require("barbecue").setup({
        show_modified = true,
      })
    end,
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
  },
  {
    "AckslD/nvim-FeMaco.lua",
    config = function()
      require("plugin-configs.femaco")
    end,
  },
  {
    "b0o/schemastore.nvim",
    event = "VeryLazy",
  },
  {
    "mfussenegger/nvim-treehopper",
    config = function()
      require("plugin-configs.treehopper")
    end,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter" },
    },
  },
  {
    "szymonwilczek/vim-be-better",
    lazy = true,
    cmd = { "VimBeBetter" },
  },
  {
    "jellydn/hurl.nvim",
    config = function()
      require("plugin-configs.hurl")
    end,
    ft = "hurl",
  },
  {
    "zbirenbaum/copilot.lua",
    dependencies = {
      "copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
    },
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("plugin-configs.copilot-lua")
    end,
    enabled = vim.fn.getenv("WSL_INTEROP") ~= vim.NIL,
  },
  {
    "nvzone/typr",
    dependencies = "nvzone/volt",
    lazy = true,
    opts = {},
    cmd = { "Typr", "TyprStats" },
  },
  {
    "NickvanDyke/opencode.nvim",
    config = function()
      require("plugin-configs.opencode")
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    config = function()
      require("plugin-configs.codecompanion")
    end,
    lazy = true,
    dependencies = {
      "ravitemer/codecompanion-history.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      {
        "<F10>",
        mode = { "n", "x", "i" },
        "<Cmd>CodeCompanionChat toggle<CR>",
        desc = "Toggle CodeCompanionChat",
      },
      {
        mode = { "n", "x" },
        "<leader>ac",
        "<Cmd>CodeCompanionActions<CR>",
        desc = "Toggle CodeCompanionActions",
      },
    },
  },
  {
    "ravitemer/mcphub.nvim",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "bundled_build.lua", -- Bundles `mcp-hub` binary along with the Neovim plugin
    config = function()
      require("plugin-configs.mcphub")
    end,
    keys = {
      { "<localleader>tH", "<cmd>MCPHub<cr>", desc = "McpHub" },
    },
  },
  {
    "andrewferrier/debugprint.nvim",
    config = function()
      require("plugin-configs.debugprint")
    end,
  },
  {
    "ThePrimeagen/refactoring.nvim",
    lazy = true,
    config = function()
      require("plugin-configs.refactoring")
    end,
    keys = require("keybindings.lazy-keybinds").refactoring,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
  },
  {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    config = function()
      require("plugin-configs.conform")
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    config = function()
      require("plugin-configs.nvim-lint")
    end,
  },
  {
    "gbprod/stay-in-place.nvim",
    config = function()
      require("stay-in-place").setup({})
    end,
  },
  {
    "folke/lazydev.nvim",
    event = "VeryLazy",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { plugins = { "nvim-dap-ui" }, types = true },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "lazy.nvim", words = { "LazyNvim" } },
      },
    },
  },
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    config = function()
      require("plugin-configs.luasnip")
    end,
    dependencies = {
      { "rafamadriz/friendly-snippets" },
    },
  },
  {
    "evesdropper/luasnip-latex-snippets.nvim",
    lazy = true,
    dependencies = {
      { "L3MON4D3/LuaSnip" },
    },
    ft = { "latex", "tex", "plaintex" },
  },
  {
    "supermaven-inc/supermaven-nvim",
    event = "VeryLazy",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<C-f>",
          clear_suggestion = "<C-]>",
          accept_word = "<C-e>",
        },
      })
    end,
    enabled = vim.fn.getenv("WSL_INTEROP") == vim.NIL,
  },
  {
    "Saghen/blink.cmp",
    config = function()
      require("plugin-configs.blink")
    end,
    version = "*",
  },
  {
    "honza/dockerfile.vim",
    ft = { "Dockerfile" },
  },
  {
    "imsnif/kdl.vim",
    ft = { "kdl" },
  },
  {
    "mustache/vim-mustache-handlebars",
    ft = { "mustache" },
  },
  {
    "cespare/vim-toml",
    ft = { "toml" },
  },
  {
    "vim-scripts/xml.vim",
    ft = { "xml" },
  },
  {
    "https://tangled.org/cuducos.me/yaml.nvim",
    opts = {
      ft = { "yaml", "yaml.helm-values" },
    },
    ft = { "yaml", "yaml.helm-values" }, -- optional
    keys = require("keybindings.lazy-keybinds").yaml_nvim,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter" },
      { "folke/snacks.nvim" }, -- optional
    },
  },
  {
    "pearofducks/ansible-vim",
    ft = { "yaml", "ansible", "ansible_hosts" },
  },
  {
    "elzr/vim-json",
    ft = { "json" },
  },
  {
    "leoluz/nvim-dap-go",
    lazy = true,
    ft = { "go" },
    config = function()
      require("plugin-configs.nvim-dap-go")
    end,
  },
  -- TODO: investigate if we still want this plugin
  {
    "olexsmir/gopher.nvim",
    lazy = true,
    config = function()
      require("plugin-configs.gopher")
    end,
    ft = { "go" },
    dependencies = { -- dependencies
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
  },
  {
    "plasticboy/vim-markdown",
    ft = { "markdown", "pandoc.markdown", "rmd" },
    config = function()
      require("plugin-configs.vim-markdown")
    end,
  },
  {
    "maskudo/devdocs.nvim",
    lazy = true,
    config = function()
      require("plugin-configs.devdocs")
    end,
    keys = {
      { "<localleader>dg", "<cmd>DevDocs get<cr>", desc = "Devdocs get" },
      { "<localleader>di", "<cmd>DevDocs install<cr>", desc = "Devdocs install" },
    },
  },
  {
    "yousefhadder/markdown-plus.nvim",
    config = function()
      require("plugin-configs.markdown-plus")
    end,
    ft = { "markdown", "text", "txt" },
  },
  {
    "Myzel394/easytables.nvim",
    ft = { "markdown", "pandoc.markdown" },
    config = function()
      require("plugin-configs.easytables")
    end,
  },
  {
    "stevearc/stickybuf.nvim",
    lazy = false,
    config = function()
      require("plugin-configs.stickybuf")
    end,
  },
  {
    "stevearc/aerial.nvim",
    event = "VeryLazy",
    config = function()
      require("plugin-configs.aerial")
    end,
  },
  --[[ #######################
     Coding
    ####################### ]]
  {
    "LudoPinelli/comment-box.nvim",
    lazy = true,
    keys = {
      { "<leader>ibl", "<cmd>CBlcbox<cr>", desc = "Left aligned box" },
      { "<leader>ibc", "<cmd>CBccbox<cr>", desc = "Centered box" },
      { "<leader>ibr", "<cmd>CBrcbox<cr>", desc = "Right aligned box" },
      { "<leader>ibd", "<cmd>CBd<cr>", desc = "Delete box" },
      { "<leader>il", "<cmd>CBcline<cr>", desc = "Centered line" },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    lazy = true,
    config = function()
      require("plugin-configs.indent-blankline")
    end,
    keys = {
      { "<localleader>ti", "<cmd>IBLToggle<CR>", noremap = true, silent = true, desc = "Toggle indentblankline" },
    },
  },
  {
    "liuchengxu/vista.vim",
    lazy = true,
    config = function()
      require("plugin-configs.vista")
    end,
    keys = {
      { "<localleader>tv", "<cmd>Vista!!<cr>", desc = "Vista bar" },
      { "<localleader>sv", "<cmd>Vista finder<cr>", desc = "Vista finder" },
    },
  },
  {
    "towolf/vim-helm",
    ft = { "helm" },
  },
  {
    "hashivim/vim-terraform",
    config = function()
      require("plugin-configs.vim-terraform")
    end,
    ft = { "tf", "tfvars", "hcl" },
  },
  {
    "fei6409/log-highlight.nvim",
    config = function()
      require("log-highlight").setup({})
    end,
  },
  {
    "jvirtanen/vim-hcl",
    ft = { "hcl" },
  },

  --[[ #######################
        Writing
        ####################### ]]
  {
    "reedes/vim-pencil",
    ft = { "markdown", "text", "tex" },
  },
  {
    "chomosuke/typst-preview.nvim",
    version = "1.*",
    ft = { "typst" },
    opts = {
      dependencies_bin = {
        ["tinymist"] = "/home/jemag/.nix-profile/bin/tinymist",
      },
    },
  },
  {
    "folke/zen-mode.nvim",
    lazy = true,
    config = function()
      require("plugin-configs.zen-mode")
    end,
    keys = {
      { "<localleader>tz", "<cmd>ZenMode<cr>", desc = "Zen mode" },
    },
  },
  {
    "junegunn/Limelight.vim",
    lazy = true,
    config = function()
      require("plugin-configs.limelight")
    end,
    keys = {
      { "<localleader>tL", "<cmd>Limelight!!<cr>", desc = "Limelight" },
    },
  },
  {
    "gbprod/substitute.nvim",
    event = "VeryLazy",
    config = function()
      require("plugin-configs.substitute")
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("plugin-configs.which-key")
    end,
  },
  {
    "echasnovski/mini.nvim",
    event = "VeryLazy",
    config = function()
      require("plugin-configs.indentscope")
      require("plugin-configs.operators")
      require("plugin-configs.mini-ai")
      require("plugin-configs.bracketed")
      require("plugin-configs.trailspace")
    end,
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("plugin-configs.nvim-surround")
    end,
  },
}, {
  readme = {
    enabled = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "tohtml",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        -- "matchit",
        -- "matchparen",
        "tar",
        "tarPlugin",
        "rrhelper",
        -- "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        "tutor",
        "rplugin",
        -- "syntax",
        -- "synmenu",
        -- "optwin",
        -- "compiler",
        -- "bugreport",
        -- "ftplugin",
      },
    },
  },
})

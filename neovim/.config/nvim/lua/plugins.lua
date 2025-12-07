-- bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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
    ---@module "quicker"
    ---@type quicker.SetupOptions
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
    version = "v2.*",
    dependencies = "saghen/blink.download",
    lazy = false,
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
    "Allaman/kustomize.nvim",
    config = function()
      require("plugin-configs.kustomize")
    end,
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
      vim.keymap.set({ "n", "x" }, "<leader>in", "<cmd>Neogen<cr>", { desc = "Neogen" })
    end,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter" },
      { "L3MON4D3/LuaSnip" },
    },
  },
  {
    "bullets-vim/bullets.vim",
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
    config = function()
      require("plugin-configs.trouble")
    end,
  },
  {
    "woosaaahh/sj.nvim",
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
    dependencies = { "nvim-mini/mini.icons" },
    config = function()
      require("plugin-configs.fyler")
    end,
  },
  {
    -- "tomasky/bookmarks.nvim",
    -- "ten3roberts/bookmarks.nvim",
    "jemag/bookmarks.nvim",
    -- branch = "feat-scoped-bookmarks",
    config = function()
      require("plugin-configs.bookmarks")
    end,
  },
  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   branch = "main",
  --   dependencies = {
  --     { "nvim-lua/plenary.nvim" },
  --     { "nvim-tree/nvim-web-devicons" }, -- not strictly required, but recommended
  --     { "MunifTanjim/nui.nvim" },
  --   },
  --   config = function()
  --     require("plugin-configs.neo-tree")
  --   end,
  -- },
  {
    "dstein64/nvim-scrollview",
    config = function()
      require("plugin-configs.scrollview")
    end,
  },
  {
    "hat0uma/csvview.nvim",
    config = function()
      require("plugin-configs.csvview")
    end,
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
    keys = {
      { "<localleader>tC", "<cmd>CsvViewToggle<cr>", desc = "Toggle CSV View" },
    },
  },
  {
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
  },
  {
    "jake-stewart/multicursor.nvim",
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
    config = function()
      require("plugin-configs.rainbow-delimiters")
    end,
  },
  {
    "Isrothy/lualine-diagnostic-message",
  },
  {
    "nvim-lualine/lualine.nvim",
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
    config = function()
      require("plugin-configs.dap")
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
    config = function()
      require("plugin-configs.render-markdown")
    end,
  },
  {
    "jbyuki/one-small-step-for-vimkind",
  },
  {
    "rcarriga/nvim-dap-ui",
    config = function()
      require("plugin-configs.nvim-dap-ui")
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    config = function()
      require("plugin-configs.nvim-dap-virtual-text")
    end,
  },
  { "mfussenegger/nvim-jdtls" },
  { "lambdalisue/suda.vim" },

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
    "EdenEast/nightfox.nvim",
    event = "User LoadColorSchemes",
  },
  {
    "Shatur95/neovim-ayu",
    priority = 1000,
  },
  {
    "habamax/vim-gruvbit",
    event = "User LoadColorSchemes",
  },

  --[[ #######################
     Interface
    ####################### ]]
  { "nvim-tree/nvim-web-devicons" },
  {
    "uga-rosa/ccc.nvim",
    config = function()
      require("ccc").setup()
    end,
    cmd = { "CccConvert", "CccPick", "CccHighlighterToggle" },
    keys = {
      { "<localleader>to", "<cmd>CccHighlighterToggle<cr>", desc = "Toggle colorizer" },
    },
  },
  {
    "jedrzejboczar/possession.nvim",
    config = function()
      require("plugin-configs.possession")
    end,
  },
  {
    "junegunn/vim-easy-align",
    config = function()
      require("plugin-configs.easyalign")
    end,
  },
  {
    "mbbill/undotree",
    config = function()
      require("plugin-configs.undotree")
    end,
  },

  { "tpope/vim-repeat" },
  --[[ #######################
     Search Plugins
    ####################### ]]
  {
    "HakonHarnes/img-clip.nvim",
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
    "esmuellert/vscode-diff.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("plugin-configs.vscode-diff")
    end,
  },
  {
    "sindrets/diffview.nvim",
    config = function()
      require("plugin-configs.diffview")
    end,
  },
  {
    "bkoropoff/clipipe",
    config = function()
      require("plugin-configs.clipipe")
    end,
    enabled = vim.fn.getenv("WSL_INTEROP") ~= vim.NIL,
  },
  {
    "wintermute-cell/gitignore.nvim",
  },
  {
    "akinsho/git-conflict.nvim",
    config = function()
      require("plugin-configs.git-conflict")
    end,
  },
  {
    "pwntester/octo.nvim",
    config = function()
      require("plugin-configs.octo")
    end,
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
  },
  {
    "afonsofrancof/worktrees.nvim",
    config = function()
      require("plugin-configs.worktree")
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
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
    commit = "e5c61b02f33b5c6538be25b2696b33b4cc91e667",
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
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "bundled_build.lua", -- Bundles `mcp-hub` binary along with the neovim plugin
    config = function()
      require("plugin-configs.mcphub")
    end,
  },
  {
    "andrewferrier/debugprint.nvim",
    config = function()
      require("plugin-configs.debugprint")
    end,
  },
  {
    "ThePrimeagen/refactoring.nvim",
    config = function()
      require("plugin-configs.refactoring")
    end,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
  },
  {
    "stevearc/conform.nvim",
    config = function()
      require("plugin-configs.conform")
    end,
  },
  {
    "mfussenegger/nvim-lint",
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
    config = function()
      require("plugin-configs.luasnip")
    end,
    dependencies = {
      { "rafamadriz/friendly-snippets" },
    },
  },
  {
    "evesdropper/luasnip-latex-snippets.nvim",
    dependencies = {
      { "L3MON4D3/LuaSnip" },
    },
    ft = { "latex", "tex", "plaintex" },
  },
  {
    "supermaven-inc/supermaven-nvim",
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
    version = "v1.*",
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
    "cuducos/yaml.nvim",
    opts = {
      ft = { "yaml", "yaml.helm-values" },
    },
    ft = { "yaml", "yaml.helm-values" }, -- optional
    keys = {
      { "<localleader>yv", "<cmd>YAMLView<cr>", desc = "Yaml view" },
      { "<localleader>yyk", "<cmd>YAMLYankKey +<cr>", desc = "Yank key" },
      { "<localleader>yyv", "<cmd>YAMLYankValue +<cr>", desc = "Yank value" },
      { "<localleader>yyf", "<cmd>YAMLYank +<cr>", desc = "Yank full" },
      { "<localleader>ys", "<cmd>YAMLSnacks<cr>", desc = "Yaml search" },
    },
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
    lazy = false,
    config = function()
      require("plugin-configs.devdocs")
    end,
    keys = {
      { "<localleader>dg", "<cmd>DevDocs get<cr>", desc = "Devdocs get" },
      { "<localleader>di", "<cmd>DevDocs install<cr>", desc = "Devdocs install" },
    },
  },
  {
    "Myzel394/easytables.nvim",
    ft = { "markdown", "pandoc.markdown" },
    config = function()
      require("plugin-configs.easytables")
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown", "pandoc.markdown", "rmd" },
    build = "cd app & npm install",
    config = function()
      require("plugin-configs.markdown-preview")
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
    config = function()
      require("plugin-configs.aerial")
    end,
  },
  --[[ #######################
     Coding
    ####################### ]]
  {
    "LudoPinelli/comment-box.nvim",
    config = function()
      require("plugin-configs.comment-box")
    end,
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
    config = function()
      require("plugin-configs.vista")
    end,
  },
  -- {
  --   "majutsushi/tagbar",
  --   config = function()
  --     require("plugin-configs.tagbar")
  --   end,
  -- },
  {
    "towolf/vim-helm",
    ft = { "helm" },
  },
  {
    "hashivim/vim-terraform",
    config = function()
      require("plugin-configs.vim-terraform")
    end,
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
    config = function()
      require("plugin-configs.zen-mode")
    end,
  },
  {
    "junegunn/Limelight.vim",
    config = function()
      require("plugin-configs.limelight")
    end,
  },
  {
    "gbprod/substitute.nvim",
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

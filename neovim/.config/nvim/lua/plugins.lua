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
      { "<localleader>tM", '<cmd>Capture messages<cr>', noremap = true, silent = true, desc = "Capture messages" },
    },
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
  {
    url = "https://gitlab.com/yorickpeterse/nvim-pqf.git",
    config = function()
      require("pqf").setup()
    end,
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
    lazy = true,
    keys = {
      { "<leader>kt", '<cmd>lua require("kubectl").toggle()<cr>', noremap = true, silent = true, desc = "Toggle kubectl.nvim" },
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
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      require("telescope").load_extension("yaml_schema")
      require("plugin-configs.yaml-companion")
    end,
    ft = { "yaml", "json" },
  },
  -- {
  --   "AckslD/nvim-trevJ.lua",
  --   config = function()
  --     require("plugin-configs.nvim-trevJ")
  --   end,
  -- },
  {
    "wurli/split.nvim",
    config = function()
      require("plugin-configs.split")
    end,
  },
  {
    "s1n7ax/nvim-window-picker",
    config = function()
      require("plugin-configs.nvim-window-picker")
    end,
  },
  {
    "mrjones2014/smart-splits.nvim",
    config = function()
      require("plugin-configs.smart-splits")
    end,
  },
  {
    "phelipetls/jsonpath.nvim",
    ft = { "json" },
  },
  {
    "google/vim-jsonnet",
    ft = { "jsonnet" },
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
    "folke/noice.nvim",
    lazy = false,
    config = function()
      require("plugin-configs.noice")
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
    "EvWilson/spelunk.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- For window drawing utilities
      "nvim-telescope/telescope.nvim", -- Optional: for fuzzy search capabilities
      "nvim-treesitter/nvim-treesitter", -- Optional: for showing grammar context
    },
    config = function()
      require("plugin-configs.spelunk")
    end,
  },
  {
    "leath-dub/snipe.nvim",
    config = function()
      require("plugin-configs.snipe")
    end,
  },
  {
    "kungfusheep/snipe-spell.nvim",
    dependencies = "leath-dub/snipe.nvim",
    config = true,
    keys = {
      { "z=", "<cmd>SnipeSpell <cr>", desc = "Snipe Spellchecker" },
    },
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
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "main",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-tree/nvim-web-devicons" }, -- not strictly required, but recommended
      { "MunifTanjim/nui.nvim" },
    },
    config = function()
      require("plugin-configs.neo-tree")
    end,
  },
  {
    "dstein64/nvim-scrollview",
    config = function()
      require("plugin-configs.scrollview")
    end,
  },
  {
    "meznaric/key-analyzer.nvim",
    cmd = "KeyAnalyzer",
    config = function()
      require("key-analyzer").setup()
    end,
  },
  { "stevearc/dressing.nvim" },
  {
    "ryanmsnyder/toggleterm-manager.nvim",
    dependencies = {
      "akinsho/nvim-toggleterm.lua",
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- only needed because it's a dependency of telescope
    },
    config = function()
      require("plugin-configs.toggleterm-manager")
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("plugin-configs.toggleterm")
    end,
  },
  -- use({
  --   "/home/jemag/Projects/github-reference/numToStr/FTerm.nvim/",
  --   config = function()
  --     require("FTerm").setup({
  --       on_stdout = function(t, job, data, name)
  --         print("terminal/n")
  --         print(vim.inspect(t))
  --         print("job/n")
  --         print(vim.inspect(job))
  --         print("data/n")
  --         print(vim.inspect(data))
  --         print("name/n")
  --         print(vim.inspect(name))
  --       end,
  --       border = "double",
  --       dimensions = {
  --         height = 0.9,
  --         width = 0.9,
  --       },
  --     })
  --   end,
  -- })
  -- ({
  --   dir = "/home/jemag/Projects/multi-term.nvim/",
  --   config = function()
  --     require("multi-term").setup({
  --       on_stdout = function(t, job, data, name)
  --         print("terminal/n")
  --         print(vim.inspect(t))
  --         print("job/n")
  --         print(vim.inspect(job))
  --         print("data/n")
  --         print(vim.inspect(data))
  --         print("name/n")
  --         print(vim.inspect(name))
  --       end,
  --       border = "double",
  --       dimensions = {
  --         height = 0.9,
  --         width = 0.9,
  --       },
  --     })
  --   end
  -- }),
  {
    "jemag/telescope-diff.nvim",
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
    },
  },
  { "airblade/vim-rooter" },
  {
    "epwalsh/obsidian.nvim",
    config = function()
      require("plugin-configs.obsidian")
    end,
  },
  {
    "glacambre/firenvim",
    build = function()
      vim.fn["firenvim#install"](0)
    end,
    config = function()
      require("plugin-configs.firenvim")
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
  },
  {
    "Kasama/nvim-custom-diagnostic-highlight",
    config = function()
      require("nvim-custom-diagnostic-highlight").setup({})
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
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
  {
    "jemag/tmux-status.nvim",
    lazy = true,
    config = function()
      require("plugin-configs.tmux-status")
    end,
  },
  {
    "jemag/nerdicons.nvim",
    branch = "configurable-register",
    -- "glepnir/nerdicons.nvim",
    cmd = "NerdIcons",
    config = function()
      require("nerdicons").setup({
        register = '"',
      })
    end,
    keys = {
      { "<leader>sI", "<cmd>NerdIcons<cr>", desc = "Pick nerd icon" },
    },
  },
  { "tweekmonster/startuptime.vim" },
  { "stevearc/profile.nvim" },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("plugin-configs.nvim-autopairs")
    end,
  },
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
    "MeanderingProgrammer/markdown.nvim",
    name = "render-markdown", -- Only needed if you have another plugin named markdown.nvim
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
  {
    "nvim-telescope/telescope-dap.nvim",
    config = function()
      require("telescope").load_extension("dap")
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
          "telescope",
          "floaterm",
          "neo-tree",
          "bufferline",
        },
      })
    end,
  },
  {
    "2giosangmitom/nightfall.nvim",
    event = "User LoadColorSchemes",
    opts = {},
  },
  {
    "fynnfluegge/monet.nvim",
    event = "User LoadColorSchemes",
  },
  {
    "oxfist/night-owl.nvim",
    event = "User LoadColorSchemes",
  },
  {
    "antonk52/lake.nvim",
    event = "User LoadColorSchemes",
  },
  {
    "bluz71/vim-nightfly-colors",
    event = "User LoadColorSchemes",
  },
  {
    "tiagovla/tokyodark.nvim",
    event = "User LoadColorSchemes",
  },
  {
    "NTBBloodbath/sweetie.nvim",
    event = "User LoadColorSchemes",
  },
  {
    "AlexvZyl/nordic.nvim",
    event = "User LoadColorSchemes",
  },
  {
    "pineapplegiant/spaceduck",
    event = "User LoadColorSchemes",
    branch = "main",
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
    "martinsione/darkplus.nvim",
    event = "User LoadColorSchemes",
  },
  {
    "catppuccin/nvim",
    event = "User LoadColorSchemes",
    name = "catppuccin",
    config = function()
      vim.g.catppuccin_flavour = "mocha"
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    event = "User LoadColorSchemes",
  },
  {
    "luisiacc/gruvbox-baby",
    event = "User LoadColorSchemes",
  },
  {
    "folke/lsp-colors.nvim",
    event = "User LoadColorSchemes",
  },
  {
    "sainnhe/sonokai",
    event = "User LoadColorSchemes",
  },
  {
    "0xstepit/flow.nvim",
    tag = "v2.0.0",
    event = "User LoadColorSchemes",
    opts = {
      -- Your configuration options here.
    },
  },
  {
    "Shatur95/neovim-ayu",
    priority = 1000,
  },
  {
    "xiantang/darcula-dark.nvim",
    event = "User LoadColorSchemes",
  },
  {
    "briones-gabriel/darcula-solid.nvim",
    event = "User LoadColorSchemes",
    dependencies = {
      { "rktjmp/lush.nvim" },
    },
  },
  {
    "romgrk/doom-one.vim",
    event = "User LoadColorSchemes",
  },
  {
    "habamax/vim-gruvbit",
    event = "User LoadColorSchemes",
  },
  {
    "kyazdani42/blue-moon",
    event = "User LoadColorSchemes",
  },
  {
    "JoosepAlviste/palenightfall.nvim",
    event = "User LoadColorSchemes",
  },
  {
    "gruvbox-community/gruvbox",
    event = "User LoadColorSchemes",
  },
  {
    "shaunsingh/nord.nvim",
    event = "User LoadColorSchemes",
  },
  {
    "franbach/miramare",
    event = "User LoadColorSchemes",
  },
  {
    "chuling/ci_dark",
    event = "User LoadColorSchemes",
  },
  {
    "olimorris/onedarkpro.nvim",
    event = "User LoadColorSchemes",
  },
  {
    "folke/tokyonight.nvim",
    event = "User LoadColorSchemes",
    opts = {
      style = "storm",
      dim_inactive = false,
    },
  },

  --[[ #######################
     Interface
    ####################### ]]
  { "nvim-tree/nvim-web-devicons" },
  {
    "vhyrro/luarocks.nvim",
    priority = 2000, -- this plugin needs to run before anything else
    opts = {
      rocks = { "magick" },
    },
    enabled = vim.fn.getenv("WSL_INTEROP") == nil,
  },
  {
    "3rd/image.nvim",
    build = false,
    config = function()
      require("plugin-configs.image")
    end,
    enabled = vim.fn.getenv("WSL_INTEROP") == vim.NIL,
  },
  {
    "eero-lehtinen/oklch-color-picker.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      -- One handed keymap recommended, you will be using the mouse
      { "<localleader>mc", "<cmd>ColorPickOklch<cr>", desc = "Color pick under cursor" },
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
    "junegunn/fzf.vim",
    config = function()
      vim.cmd("source ~/.config/nvim/plugin-configs/fzf.vim")
    end,
    dependencies = {
      "junegunn/fzf",
    },
  },

  {
    "HakonHarnes/img-clip.nvim",
    config = function()
      require("plugin-configs.img-clip")
    end,
  },
  { "nvim-telescope/telescope-media-files.nvim" },
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      require("plugin-configs.telescope-config")
    end,
    dependencies = {
      { "nvim-telescope/telescope-live-grep-args.nvim" },
      { "nvim-telescope/telescope-ui-select.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "tsakirist/telescope-lazy.nvim" },
      { "debugloop/telescope-undo.nvim" },
      { "aaronhallaert/ts-advanced-git-search.nvim" },
      { "molecule-man/telescope-menufacture" },
    },
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
    "sindrets/diffview.nvim",
    config = function()
      require("plugin-configs.diffview")
    end,
  },
  {
    "wintermute-cell/gitignore.nvim",
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
    },
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
  },
  {
    "Willem-J-an/adopure.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      vim.g.adopure = {}
    end,
  },
  {
    "NeogitOrg/neogit",
    config = function()
      require("plugin-configs.neogit")
    end,
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
  },
  {
    "ThePrimeagen/git-worktree.nvim",
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
    "zeioth/garbage-day.nvim",
    event = "VeryLazy",
    opts = {
      grace_period = 300,
      timeout = 3000,
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lsp")
    end,
  },
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
    "ThePrimeagen/vim-be-good",
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
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
      require("chatgpt").setup({
        keymaps = {
          submit = "<CR>",
        },
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
  {
    "nvimtools/none-ls.nvim",
    config = function()
      require("plugin-configs.null-ls")
    end,
  },
  {
    "gbprod/stay-in-place.nvim",
    config = function()
      require("stay-in-place").setup({})
    end,
  },
  {
    "williamboman/mason.nvim",
    config = function()
      require("plugin-configs.mason")
    end,
    dependencies = {
      { "WhoIsSethDaniel/mason-tool-installer.nvim" },
    },
  },
  { "williamboman/mason-lspconfig.nvim" },

  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "benfowler/telescope-luasnip.nvim",
    dependencies = {
      { "L3MON4D3/LuaSnip" },
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
  },
  {
    "Saghen/blink.cmp",
    config = function()
      require("plugin-configs.blink")
    end,
    version = "v0.*",
  },
  -- {
  --   "hrsh7th/nvim-cmp",
  --   config = function()
  --     require("plugin-configs.nvim-cmp")
  --   end,
  --   dependencies = {
  --     { "hrsh7th/cmp-nvim-lsp" },
  --     { "saadparwaiz1/cmp_luasnip" },
  --     { "hrsh7th/cmp-buffer" },
  --     { "hrsh7th/cmp-path" },
  --     { "onsails/lspkind-nvim" },
  --     { "lukas-reineke/cmp-rg" },
  --     { "rcarriga/cmp-dap" },
  --   },
  -- },
  -- {
  --   "Gelio/cmp-natdat",
  --   config = function()
  --     require("cmp_natdat").setup()
  --   end,
  --   dependencies = {
  --     "hrsh7th/nvim-cmp",
  --   },
  -- },
  -- {
  --   "hrsh7th/cmp-cmdline",
  --   config = function()
  --     require("plugin-configs.cmp-cmdline")
  --   end,
  -- },

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
    ft = { "yaml" }, -- optional
    dependencies = {
      { "nvim-treesitter/nvim-treesitter" },
      { "nvim-telescope/telescope.nvim" }, -- optional
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
  {
    "olexsmir/gopher.nvim",
    config = function()
      require("plugin-configs.gopher")
    end,
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
    "jtratner/vim-flavored-markdown",
    ft = { "markdown", "pandoc.markdown", "rmd" },
  },

  {
    "nelstrom/vim-markdown-folding",
    ft = { "markdown", "pandoc.markdown", "rmd" },
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
    config = function()
      require("plugin-configs.indent-blankline")
    end,
  },
  {
    "liuchengxu/vista.vim",
    config = function()
      require("plugin-configs.vista")
    end,
  },

  {
    "majutsushi/tagbar",
    config = function()
      require("plugin-configs.tagbar")
    end,
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
    version = false,
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
})

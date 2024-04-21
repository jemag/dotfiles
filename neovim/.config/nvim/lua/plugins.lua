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
    "someone-stole-my-name/yaml-companion.nvim",
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
  {
    "AckslD/nvim-trevJ.lua",
    config = function()
      require("plugin-configs.nvim-trevJ")
    end,
  },
  {
    "s1n7ax/nvim-window-picker",
    version = "v1.*",
    config = function()
      require("plugin-configs.nvim-window-picker")
    end,
  },
  {
    "anuvyklack/pretty-fold.nvim",
    config = function()
      require("pretty-fold").setup({})
      require("fold-preview").setup()
    end,
    dependencies = {
      { "anuvyklack/nvim-keymap-amend" },
      { "anuvyklack/fold-preview.nvim" },
    },
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
    "svban/YankAssassin.vim",
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
    "rcarriga/nvim-notify",
    config = function()
      require("plugin-configs.nvim-notify")
    end,
  },
  {
    "windwp/nvim-spectre",
    config = function()
      require("spectre").setup()
      vim.keymap.set("n", "<localleader>tS", '<cmd>lua require("spectre").open()<CR>', { desc = "Open Spectre" })
    end,
    keys = { "<localleader>tS" },
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
    "folke/trouble.nvim",
    config = function()
      require("plugin-configs.trouble")
    end,
    branch = "dev"
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
    "otavioschwanck/arrow.nvim",
    config = function()
      require("plugin-configs.arrow")
    end,
  },
  {
    -- "tomasky/bookmarks.nvim",
    "ten3roberts/bookmarks.nvim",
    branch = "feat-scoped-bookmarks",
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
    "mrjones2014/legendary.nvim",
    config = function()
      vim.keymap.set("n", "<localleader>sK", "<cmd>Legendary<cr>", { desc = "Legendary keymaps" })
    end,
    keys = { "<localleader>sK" },
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
    "LeonHeidelbach/trailblazer.nvim",
    config = function()
      require("plugin-configs.trailblazer")
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
  { "tweekmonster/startuptime.vim" },
  { "stevearc/profile.nvim" },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("plugin-configs.nvim-autopairs")
    end,
  },
  { "LunarVim/bigfile.nvim" },
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
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("render-markdown").setup({})
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
  {
    "miversen33/sunglasses.nvim",
    config = function()
      require("plugin-configs.sunglasses")
    end,
  },

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
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("plugin-configs.nvim-colorizer")
    end,
    keys = {
      { "<localleader>tC", "<cmd>ColorizerToggle<cr>", desc = "Colorizer" }
    },
  },

  {
    "jedrzejboczar/possession.nvim",
    config = function()
      require("plugin-configs.possession")
    end,
  },
  -- TODO: Check if still needed
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("plugin-configs.project_nvim")
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
    "tpope/vim-fugitive",
    config = function()
      require("plugin-configs.fugitive")
    end,
  },
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
    keys = { "<leader>go" },
  },
  {
    "linrongbin16/gitlinker.nvim",
    config = function()
      require("plugin-configs.gitlinker")
    end,
  },
  {
    "NeogitOrg/neogit",
    config = function()
      require("plugin-configs.neogit")
    end,
    branch = "nightly"
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
  {
    "lewis6991/hover.nvim",
    config = function()
      require("plugin-configs.hover")
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
      require("barbecue").setup()
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
    "dpayne/CodeGPT.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("codegpt.config")
    end,
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

  { "folke/lua-dev.nvim" },
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
    "hrsh7th/nvim-cmp",
    config = function()
      require("plugin-configs.nvim-cmp")
    end,
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "onsails/lspkind-nvim" },
      { "lukas-reineke/cmp-rg" },
      { "rcarriga/cmp-dap" },
    },
  },
  {
    "Exafunction/codeium.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("codeium").setup({})
    end,
  },
  {
    "Gelio/cmp-natdat",
    config = function()
      require("cmp_natdat").setup()
    end,
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
  },
  {
    "hrsh7th/cmp-cmdline",
    config = function()
      require("plugin-configs.cmp-cmdline")
    end,
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
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },
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
    "echasnovski/mini.nvim",
    config = function()
      require("plugin-configs.indentscope")
      require("plugin-configs.clue")
      require("plugin-configs.operators")
      require("plugin-configs.mini-ai")
      require("plugin-configs.bracketed")
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

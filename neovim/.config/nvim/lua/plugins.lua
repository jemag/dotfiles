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
    cmd = "Capture"
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
    "gaoDean/autolist.nvim",
    config = function()
      require("plugin-configs.autolist")
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
    ft = { "yaml", "json" }
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
    ft = { "json" }
  },
  {
    "google/vim-jsonnet",
    ft = { "jsonnet" }
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
    "gbprod/substitute.nvim",
    config = function()
      require("plugin-configs.substitute")
    end,
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
    "sindrets/winshift.nvim",
    config = function()
      require("plugin-configs.winshift")
    end,
  },
  {
    "windwp/nvim-spectre",
    config = function()
      require("spectre").setup()
      vim.keymap.set("n", "<localleader>tS", '<cmd>lua require("spectre").open()<CR>', { desc = "Open Spectre" })
    end,
    keys = { "<localleader>tS" }
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
    "folke/flash.nvim",
    config = function ()
      require("plugin-configs.flash")
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
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
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
    config = function ()
      require("plugin-configs.scrollview")
    end
  },
  {
    "mrjones2014/legendary.nvim",
    config = function()
      vim.keymap.set("n", "<localleader>sK", "<cmd>Legendary<cr>", { desc = "Legendary keymaps" })
    end,
    keys = { "<localleader>sK" }
  },
  { "stevearc/dressing.nvim" },
  {
    "voldikss/vim-floaterm",
    config = function()
      require("plugin-configs.vim-floaterm")
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
    }
  },
  { "airblade/vim-rooter" },
  {
    "LeonHeidelbach/trailblazer.nvim",
    config = function()
      require("plugin-configs.trailblazer")
    end,
  },
  {
    "MattesGroeger/vim-bookmarks",
    config = function()
      require("plugin-configs.vim-bookmarks")
    end,
    init = function()
      vim.g.bookmark_no_default_key_mappings = 1
    end,
  },
  {
    "tom-anders/telescope-vim-bookmarks.nvim",
    config = function()
      require("plugin-configs.telescope-vim-bookmarks")
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
    "mrjones2014/nvim-ts-rainbow",
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
  {
    "mfussenegger/nvim-dap",
    config = function()
      require("plugin-configs.dap")
    end,
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
    "gennaro-tedesco/nvim-peekup",
    config = function()
      require("plugin-configs.nvim-peekup")
    end,
  },

  -- Themes
  {
    "loctvl842/monokai-pro.nvim",
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
    end
  },
  {
    "antonk52/lake.nvim",
  },
  {
    "bluz71/vim-nightfly-colors",
  },
  {
    "tiagovla/tokyodark.nvim",
  },
  {
    "NTBBloodbath/sweetie.nvim",
  },
  {
    "levouh/tint.nvim",
    config = function()
      require("plugin-configs.tint")
    end,
  },
  {
    "AlexvZyl/nordic.nvim",
  },
  {
    "pineapplegiant/spaceduck",
    branch = "main",
  },
  {
    "rebelot/kanagawa.nvim",
    config = function()
      require('kanagawa').setup({
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = "none"
              }
            }
          }
        }
      })
    end,
  },
  {
    "martinsione/darkplus.nvim",
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      vim.g.catppuccin_flavour = "mocha"
    end,
  },
  {
    "EdenEast/nightfox.nvim",
  },
  {
    "luisiacc/gruvbox-baby",
  },
  {
    "folke/lsp-colors.nvim",
  },
  {
    "lvimuser/lsp-inlayhints.nvim",
    config = function ()
      require("plugin-configs.inlayhints")
    end,
    branch = "anticonceal",
  },
  {
    "sainnhe/sonokai",
  },
  {
    "Shatur95/neovim-ayu",
    priority = 1000,
  },
  {
    "xiantang/darcula-dark.nvim",
  },
  {
    "briones-gabriel/darcula-solid.nvim",
    dependencies = {
      { "rktjmp/lush.nvim" },
    },
  },
  {
    "romgrk/doom-one.vim",
  },
  {
    "habamax/vim-gruvbit",
  },
  {
    "kyazdani42/blue-moon",
  },
  {
    "JoosepAlviste/palenightfall.nvim",
  },
  {
    "gruvbox-community/gruvbox",
  },
  {
    "shaunsingh/nord.nvim",
  },
  {
    "franbach/miramare",
  },
  {
    "chuling/ci_dark",
  },
  {
    "olimorris/onedarkpro.nvim",
  },
  {
    "folke/tokyonight.nvim",
    config = function()
      vim.g.tokyonight_style = "storm"
    end,
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
    keys = { "<localleader>tC" }
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
      "junegunn/fzf"
    },
  },

  { "nvim-telescope/telescope-media-files.nvim" },
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      require("plugin-configs.telescope-config")
    end,
    dependencies = {
      { "nvim-telescope/telescope-live-grep-args.nvim" },
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
    }
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
      require("octo").setup()
    end,
    cmd = "Octo",
  },
  {
    "ruifm/gitlinker.nvim",
    config = function()
      require("plugin-configs.gitlinker")
    end,
  },
  {
    "NeogitOrg/neogit",
    config = function()
      require("plugin-configs.neogit")
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
    "james1236/backseat.nvim",
    config = function()
      require("backseat").setup({
        -- Alternatively, set the env var $OPENAI_API_KEY by putting "export OPENAI_API_KEY=sk-xxxxx" in your ~/.bashrc
        openai_model_id = 'gpt-3.5-turbo', --gpt-4 (If you do not have access to a model, it says "The model does not exist")
        })
      end,
  },
  {
    "dpayne/CodeGPT.nvim",
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
    },
    config = function()
      require("codegpt.config")
    end
  },
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
      require("chatgpt").setup({
        keymaps = {
          submit = "<CR>"
        }
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    }
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
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
    ft = { "latex", "tex", "plaintex" }
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
    },
  },
  {
    "jemag/codeium.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("codeium").setup({
      })
    end
  },
  {
    "hrsh7th/cmp-cmdline",
    config = function()
      require("plugin-configs.cmp-cmdline")
    end,
    dependencies = {
      { "dmitmel/cmp-cmdline-history" },
    },
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
    ft= { "helm", }
  },
  {
    "hashivim/vim-terraform",
    config = function()
      require("plugin-configs.vim-terraform")
    end,
  },

  {
    "jvirtanen/vim-hcl",
    ft= { "hcl" },
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
    "echasnovski/mini.indentscope",
    config = function()
      require("plugin-configs.indentscope")
    end,
  },
  {
    "echasnovski/mini.clue",
    config = function()
      require("plugin-configs.clue")
    end,
  },
  {
    "echasnovski/mini.ai",
    config = function()
      require("plugin-configs.mini-ai")
    end,
  },
  {
    "echasnovski/mini.bracketed",
    config = function()
      require("plugin-configs.bracketed")
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
    enabled = false
  }
})

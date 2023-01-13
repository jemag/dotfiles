-- bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "git@github.com:folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup({
  { "tyru/capture.vim" },
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
    "luukvbaal/statuscol.nvim",
    config = function()
      require("plugin-configs.statuscol")
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
    "edluffy/specs.nvim",
    config = function()
      require("plugin-configs.specs")
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
  },
  {
    "google/vim-jsonnet",
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
  { "milisims/nvim-luaref" },
  { "nanotee/luv-vimdocs" },
  {
    "4513ECHO/vim-readme-viewer",
    cmd = "PackerReadme",
    config = function()
      vim.g["readme_viewer#plugin_manager"] = "packer.nvim"
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
  },
  {
    "ethanholz/nvim-lastplace",
    config = function()
      require("nvim-lastplace").setup({})
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
    "romgrk/barbar.nvim",
    lazy = false,
    config = function()
      require("plugin-configs.barbar")
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "main",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "kyazdani42/nvim-web-devicons" }, -- not strictly required, but recommended
      { "MunifTanjim/nui.nvim" },
    },
    config = function()
      require("plugin-configs.neo-tree")
    end,
  },
  {
    "dstein64/nvim-scrollview",
  },
  {
    "mrjones2014/legendary.nvim",
    config = function()
      vim.keymap.set("n", "<localleader>sK", "<cmd>Legendary<cr>", { desc = "Legendary keymaps" })
    end,
  },
  { "stevearc/dressing.nvim" },
  { "folke/which-key.nvim" },
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
  -- use({
  --   "/home/jemag/Projects/multi-term.nvim/",
  --[[ config = function()
        require("multi-term").setup({
          on_stdout = function(t, job, data, name)
            print("terminal/n")
            print(vim.inspect(t))
            print("job/n")
            print(vim.inspect(job))
            print("data/n")
            print(vim.inspect(data))
            print("name/n")
            print(vim.inspect(name))
          end,
          border = "double",
          dimensions = {
            height = 0.9,
            width = 0.9,
          },
        })
      end ]]
  -- })
  { "airblade/vim-rooter" },
  {
    "airblade/vim-current-search-match",
    config = function()
      vim.g.current_search_match = "IncSearch"
    end,
  },
  {
    "jinh0/eyeliner.nvim",
    config = function()
      require("plugin-configs.eyeliner")
    end,
  },
  {
    "j-morano/buffer_manager.nvim",
    config = function()
      require("plugin-configs.buffer_manager")
    end,
  },
  {
    "woosaaahh/sj.nvim",
    config = function()
      require("plugin-configs.sj")
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
    "editorconfig/editorconfig-vim",
    config = function()
      require("plugin-configs.editorconfig-vim")
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
    "nvim-treesitter/playground",
  },
  {
    "michaeljsmith/vim-indent-object",
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  {
    "mrjones2014/nvim-ts-rainbow",
  },
  {
    "hoob3rt/lualine.nvim",
    config = function()
      require("plugin-configs.lualine")
    end,
  },
  {
    "nyngwang/murmur.lua",
    config = function()
      require("plugin-configs.murmur")
    end,
  },
  { "tweekmonster/startuptime.vim" },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("plugin-configs.nvim-autopairs")
    end,
  },
  { "gfanto/fzf-lsp.nvim" },
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
  { "equalsraf/neovim-gui-shim" },
  { "lambdalisue/suda.vim" },
  {
    "gennaro-tedesco/nvim-peekup",
    config = function()
      require("plugin-configs.nvim-peekup")
    end,
  },

  -- Themes
  {
    "levouh/tint.nvim",
    config = function()
      require("plugin-configs.tint")
    end,
  },
  {
    "kartikp10/noctis.nvim",
    dependencies = {
      { "rktjmp/lush.nvim" },
    },
  },
  {
    "sam4llis/nvim-tundra",
  },
  {
    "pineapplegiant/spaceduck",
    branch = "main",
  },
  {
    "rebelot/kanagawa.nvim",
  },
  {
    "rmehri01/onenord.nvim",
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
  { "folke/lsp-colors.nvim" },
  { "sainnhe/sonokai" },
  {
    "Shatur95/neovim-ayu",
    lazy = false,
    priority = 1000,
  },
  { "doums/darcula" },
  {
    "briones-gabriel/darcula-solid.nvim",
    dependencies = {
      { "rktjmp/lush.nvim" },
    },
  },
  { "aonemd/kuroi.vim" },
  { "romgrk/doom-one.vim" },
  { "habamax/vim-gruvbit" },
  { "kyazdani42/blue-moon" },
  { "drewtempelmeyer/palenight.vim" },
  { "heraldofsolace/nisha-vim" },
  { "gruvbox-community/gruvbox" },
  { "shaunsingh/nord.nvim" },
  { "franbach/miramare" },
  { "chuling/ci_dark" },
  { "joshdick/onedark.vim" },
  {
    "folke/tokyonight.nvim",
    config = function()
      vim.g.tokyonight_style = "storm"
    end,
  },
  --[[ #######################
     Plugin development
    ####################### ]]
  { "nvim-lua/plenary.nvim" },

  --[[ #######################
     Interface
    ####################### ]]
  { "kyazdani42/nvim-web-devicons" },

  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("plugin-configs.nvim-colorizer")
    end,
  },

  {
    "ludovicchabant/vim-gutentags",
    config = function()
      require("plugin-configs.vim-gutentags")
    end,
  },
  {
    "jedrzejboczar/possession.nvim",
    config = function()
      require("plugin-configs.possession")
    end,
  },
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
    "junegunn/fzf",
    build = "./install --all",
  },
  {
    "junegunn/fzf.vim",
    dependencies = {
      { "junegunn/fzf" },
    },
    config = function()
      vim.cmd("source ~/.config/nvim/plugin-configs/fzf.vim")
    end,
  },

  { "nvim-lua/popup.nvim" },
  { "nvim-telescope/telescope-media-files.nvim" },
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      require("plugin-configs.telescope-config")
    end,
    dependencies = {
      { "nvim-telescope/telescope-live-grep-args.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
  },

  --[[ #######################
     Database
    ####################### ]]
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
  },
  {
    "TimUntersberger/neogit",
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
    "SmiteshP/nvim-gps",
    config = function()
      require("nvim-gps").setup()
    end,
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

  {
    "j-hui/fidget.nvim",
    config = function()
      require("plugin-configs.fidget")
    end,
  },
  {
    "ray-x/lsp_signature.nvim",
  },
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
    "gorbit99/codewindow.nvim",
    config = function()
      require("plugin-configs.codewindow")
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
    "lukas-reineke/headlines.nvim",
    commit = "347ef0371451d9bfbf010c6743fb74997b5b9a80",
    config = function()
      require("headlines").setup()
    end,
  },
  {
    "lukas-reineke/virt-column.nvim",
    config = function()
      vim.opt.colorcolumn = "120"
      vim.api.nvim_create_autocmd({ "ColorScheme" }, {
        pattern = "*",
        command = "highlight clear colorColumn",
        desc = "Clear colorcolumn",
      })
      require("virt-column").setup()
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

  { "towolf/vim-helm" },
  {
    "hashivim/vim-terraform",
    config = function()
      require("plugin-configs.vim-terraform")
    end,
  },

  { "jvirtanen/vim-hcl" },

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
    "echasnovski/mini.ai",
    config = function()
      require("plugin-configs.mini-ai")
    end,
  },
  {
    "kylechui/nvim-surround",
    config = function()
      require("plugin-configs.nvim-surround")
    end,
  },
})

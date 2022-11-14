-- bootstrap packer
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end

execute("packadd packer.nvim")
return require("packer").startup({
  function(use)
    -- Packer can manage itself as an optional plugin
    use({ "wbthomason/packer.nvim", opt = true })
    use({ "tyru/capture.vim" })
    --[[ #######################
     General
    ####################### ]]
    use({
      "kevinhwang91/nvim-bqf",
      config = function()
        require("plugin-configs.bqf")
      end,
    })
    use({
      "https://gitlab.com/yorickpeterse/nvim-pqf.git",
      config = function()
        require("pqf").setup()
      end,
    })
    -- Scope buffers to their specific tab
    use({
      "tiagovla/scope.nvim",
      config = function()
        require("scope").setup()
      end,
    })
    use({
      "gaoDean/autolist.nvim",
      config = function()
        require("plugin-configs.autolist")
      end,
    })
    use({
      "smjonas/live-command.nvim",
      config = function()
        require("plugin-configs.live-command")
      end,
    })

    use({
      "someone-stole-my-name/yaml-companion.nvim",
      requires = {
        { "neovim/nvim-lspconfig" },
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope.nvim" },
      },
      config = function()
        require("telescope").load_extension("yaml_schema")
        require("plugin-configs.yaml-companion")
      end,
    })
    use({
      "AckslD/nvim-trevJ.lua",
      config = function()
        require("plugin-configs.nvim-trevJ")
      end,
    })
    use({
      "s1n7ax/nvim-window-picker",
      tag = "v1.*",
      config = function()
        require("plugin-configs.nvim-window-picker")
      end,
    })
    use({
      "edluffy/specs.nvim",
      config = function()
        require("plugin-configs.specs")
      end,
    })
    use({
      "anuvyklack/pretty-fold.nvim",
      config = function()
        require("pretty-fold").setup({})
        require("fold-preview").setup()
      end,
      requires = {
        "anuvyklack/nvim-keymap-amend",
        "anuvyklack/fold-preview.nvim",
      },
    })
    use({
      "mrjones2014/smart-splits.nvim",
      config = function()
        require("plugin-configs.smart-splits")
      end,
    })
    use({
      "phelipetls/jsonpath.nvim",
    })
    use({
      "google/vim-jsonnet",
    })
    use({
      "svban/YankAssassin.vim",
    })
    use({
      "danymat/neogen",
      config = function()
        require("neogen").setup({
          enabled = true,
          snippet_engine = "luasnip",
        })
        vim.keymap.set({ "n", "x" }, "<leader>in", "<cmd>Neogen<cr>", { desc = "Neogen" })
      end,
      requires = {
        "nvim-treesitter/nvim-treesitter",
        "L3MON4D3/LuaSnip",
      },
    })
    use({
      "gbprod/substitute.nvim",
      config = function()
        require("plugin-configs.substitute")
      end,
    })
    use({ "milisims/nvim-luaref" })
    use({ "nanotee/luv-vimdocs" })
    use({
      "4513ECHO/vim-readme-viewer",
      opt = true,
      cmd = "PackerReadme",
      config = function()
        vim.g["readme_viewer#plugin_manager"] = "packer.nvim"
      end,
    })
    use({
      "haya14busa/vim-asterisk",
      config = function()
        require("plugin-configs.vim-asterisk")
      end,
    })
    use({
      "rcarriga/nvim-notify",
      config = function()
        require("plugin-configs.nvim-notify")
      end,
    })
    use({
      "sindrets/winshift.nvim",
      config = function()
        require("winshift").setup()
      end,
    })
    use({
      "windwp/nvim-spectre",
      config = function()
        require("spectre").setup()
        vim.keymap.set("n", "<localleader>tS", '<cmd>lua require("spectre").open()<CR>', { desc = "Open Spectre" })
      end,
    })
    use({
      "ethanholz/nvim-lastplace",
      config = function()
        require("nvim-lastplace").setup({})
      end,
    })
    use({
      "folke/todo-comments.nvim",
      config = function()
        require("plugin-configs.todo-comments")
      end,
    })
    use({
      "romgrk/barbar.nvim",
      config = function()
        require("plugin-configs.barbar")
      end,
    })
    use({
      "nyngwang/NeoZoom.lua",
      config = function()
        require("plugin-configs.neozoom")
      end,
    })
    use({
      "nvim-neo-tree/neo-tree.nvim",
      branch = "main",
      requires = {
        "nvim-lua/plenary.nvim",
        "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
      },
      config = function()
        require("plugin-configs.neo-tree")
      end,
    })
    use({
      "dstein64/nvim-scrollview",
    })
    use({
      "karb94/neoscroll.nvim",
      config = function()
        require("plugin-configs.neoscroll")
      end,
    })
    use({
      "mrjones2014/legendary.nvim",
      config = function()
        vim.keymap.set("n", "<localleader>sK", "<cmd>Legendary<cr>", { desc = "Legendary keymaps" })
      end,
    })
    use({ "stevearc/dressing.nvim" })
    use({
      "folke/which-key.nvim",
    })
    use({
      "rainbowhxch/accelerated-jk.nvim",
      config = function()
        require("plugin-configs.acceleratedjk")
      end,
    })
    use({
      "voldikss/vim-floaterm",
      config = function()
        require("plugin-configs.vim-floaterm")
      end,
    })
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
    use("airblade/vim-rooter")
    use({
      "airblade/vim-current-search-match",
      config = function()
        vim.g.current_search_match = "IncSearch"
      end,
    })
    use({
      "jinh0/eyeliner.nvim",
      config = function()
        require("eyeliner").setup({
          highlight_on_key = true,
        })
      end,
    })
    use({
      "woosaaahh/sj.nvim",
      config = function()
        require("plugin-configs.sj")
      end,
    })
    use({
      "MattesGroeger/vim-bookmarks",
      config = function()
        require("plugin-configs.vim-bookmarks")
      end,
    })
    use({
      "tom-anders/telescope-vim-bookmarks.nvim",
      after = { "telescope.nvim" },
      config = function()
        require("plugin-configs.telescope-vim-bookmarks")
      end,
    })
    use({
      "editorconfig/editorconfig-vim",
      config = function()
        require("plugin-configs.editorconfig-vim")
      end,
    })
    use({
      "glacambre/firenvim",
      run = function()
        vim.fn["firenvim#install"](0)
      end,
      config = function()
        require("plugin-configs.firenvim")
      end,
    })
    use({
      "vifm/vifm.vim",
      config = function()
        require("plugin-configs.vifm")
      end,
    })
    use({
      "nvim-treesitter/nvim-treesitter",
      run = function()
        vim.cmd([[TSUpdate]])
      end,
      config = function()
        require("plugin-configs.nvim-treesitter")
      end,
    })
    use({
      "Kasama/nvim-custom-diagnostic-highlight",
      config = function()
        require("nvim-custom-diagnostic-highlight").setup({})
      end,
    })
    use({
      "nvim-treesitter/playground",
    })
    use({
      "michaeljsmith/vim-indent-object",
    })
    use({
      "nvim-treesitter/nvim-treesitter-textobjects",
    })
    use({
      "p00f/nvim-ts-rainbow",
    })
    use({
      "hoob3rt/lualine.nvim",
      config = function()
        require("plugin-configs.lualine")
      end,
    })
    use({
      "RRethy/vim-illuminate",
      config = function()
        require("plugin-configs.vim-illuminate")
      end,
    })
    use("tweekmonster/startuptime.vim")
    use({
      "windwp/nvim-autopairs",
      config = function()
        require("plugin-configs.nvim-autopairs")
      end,
    })
    use("gfanto/fzf-lsp.nvim")
    use("mfussenegger/nvim-dap")
    use({
      "rcarriga/nvim-dap-ui",
      config = function()
        require("plugin-configs.nvim-dap-ui")
      end,
    })
    use({
      "theHamsta/nvim-dap-virtual-text",
      config = function()
        require("plugin-configs.nvim-dap-virtual-text")
      end,
    })
    use({
      "nvim-telescope/telescope-dap.nvim",
      config = function()
        require("telescope").load_extension("dap")
      end,
    })
    use("mfussenegger/nvim-jdtls")
    use("equalsraf/neovim-gui-shim")
    use("lambdalisue/suda.vim")
    use({
      "gennaro-tedesco/nvim-peekup",
      config = function()
        require("plugin-configs.nvim-peekup")
      end,
    })

    -- Themes

    use({
      "nvim-zh/colorful-winsep.nvim",
      config = function()
        require("colorful-winsep").setup({})
      end,
      -- TODO: waiting for plugin to stabilise before using main
      commit = "dbdf5ac62273385638c5ba9dd9017e9dd0fdb8d8",
    })
    use({
      "levouh/tint.nvim",
      config = function()
        require("plugin-configs.tint")
      end,
    })
    use({
      "kartikp10/noctis.nvim",
      requires = { "rktjmp/lush.nvim" },
    })
    use({
      "sam4llis/nvim-tundra",
    })
    use({
      "pineapplegiant/spaceduck",
      branch = "main",
    })
    use({
      "rebelot/kanagawa.nvim",
    })
    use({
      "rmehri01/onenord.nvim",
    })
    use({
      "martinsione/darkplus.nvim",
    })
    use({
      "catppuccin/nvim",
      as = "catppuccin",
      config = function()
        vim.g.catppuccin_flavour = "mocha"
      end,
    })
    use({
      "EdenEast/nightfox.nvim",
    })
    use({
      "luisiacc/gruvbox-baby",
    })
    -- TODO: wait until the lua queries are removed or fixed to re-enable
    -- use({
    --   "eddyekofo94/gruvbox-flat.nvim",
    --   config = function()
    --     vim.g.gruvbox_flat_style = "dark"
    --   end,
    -- })
    use("folke/lsp-colors.nvim")
    use("sainnhe/sonokai")
    use({
      "Shatur95/neovim-ayu",
    })
    use("doums/darcula")
    use({ "briones-gabriel/darcula-solid.nvim", requires = "rktjmp/lush.nvim" })
    use("aonemd/kuroi.vim")
    use("romgrk/doom-one.vim")
    use("habamax/vim-gruvbit")
    use("kyazdani42/blue-moon")
    use("drewtempelmeyer/palenight.vim")
    use("heraldofsolace/nisha-vim")
    use("ghifarit53/tokyonight-vim")
    use("gruvbox-community/gruvbox")
    use("shaunsingh/nord.nvim")
    use("franbach/miramare")
    use("chuling/ci_dark")
    use({
      "sonph/onehalf",
      rtp = "vim",
    })
    use("joshdick/onedark.vim")
    use({
      "folke/tokyonight.nvim",
      config = function()
        vim.g.tokyonight_style = "storm"
      end,
    })
    --[[ #######################
     Plugin development
    ####################### ]]
    use("nvim-lua/plenary.nvim")

    --[[ #######################
     Interface
    ####################### ]]
    use("kyazdani42/nvim-web-devicons")

    use({
      "NvChad/nvim-colorizer.lua",
      config = function()
        require("plugin-configs.nvim-colorizer")
      end,
    })

    use({
      "ludovicchabant/vim-gutentags",
      config = function()
        require("plugin-configs.vim-gutentags")
      end,
    })
    use({
      "jedrzejboczar/possession.nvim",
      config = function()
        require("plugin-configs.possession")
      end,
    })
    use({
      "ahmedkhalf/project.nvim",
      config = function()
        require("plugin-configs.project_nvim")
      end,
      after = { "telescope.nvim" },
    })
    use({
      "junegunn/vim-easy-align",
      config = function()
        require("plugin-configs.easyalign")
      end,
    })

    use({
      "mbbill/undotree",
      config = function()
        require("plugin-configs.undotree")
      end,
    })

    use("tpope/vim-repeat")
    --[[ #######################
     Search Plugins
    ####################### ]]
    use({
      "junegunn/fzf",
      run = "./install --all",
    })
    use({
      "junegunn/fzf.vim",
      requires = { "junegunn/fzf" },
      config = function()
        vim.cmd("source ~/.config/nvim/plugin-configs/fzf.vim")
      end,
    })

    use("nvim-lua/popup.nvim")
    use({
      "nvim-telescope/telescope-fzf-native.nvim",
      run = "make",
    })
    use("nvim-telescope/telescope-media-files.nvim")
    use({
      "nvim-telescope/telescope.nvim",
      config = function()
        require("plugin-configs.telescope-config")
      end,
      requires = {
        { "nvim-telescope/telescope-live-grep-args.nvim" },
      },
    })

    --[[ #######################
     Database
    ####################### ]]
    use({
      "tpope/vim-dadbod",
      opt = true,
      cmd = "DB",
    })
    --[[ #######################
     Git
    ####################### ]]
    use({
      "tpope/vim-fugitive",
      config = function()
        require("plugin-configs.fugitive")
      end,
    })
    use({
      "sindrets/diffview.nvim",
      config = function()
        require("plugin-configs.diffview")
      end,
    })
    use({
      "akinsho/git-conflict.nvim",
      config = function()
        require("plugin-configs.git-conflict")
      end,
    })
    use({
      "pwntester/octo.nvim",
      config = function()
        require("octo").setup()
      end,
    })
    use({
      "TimUntersberger/neogit",
      config = function()
        require("plugin-configs.neogit")
      end,
    })
    use({
      "lewis6991/gitsigns.nvim",
      config = function()
        require("plugin-configs.gitsigns")
      end,
    })

    --[[ #######################
     Language
    ####################### ]]
    use({
      "neovim/nvim-lspconfig",
      config = function()
        require("lsp")
      end,
    })
    use({
      "SmiteshP/nvim-gps",
      config = function()
        require("nvim-gps").setup()
      end,
    })
    use({
      "b0o/schemastore.nvim",
    })
    use({
      "mfussenegger/nvim-treehopper",
      config = function()
        require("plugin-configs.treehopper")
      end,
      requires = {
        { "nvim-treesitter/nvim-treesitter" },
      },
    })
    use({
      "ThePrimeagen/vim-be-good",
    })
    use({
      "ThePrimeagen/refactoring.nvim",
      config = function()
        require("plugin-configs.refactoring")
      end,
      requires = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-treesitter/nvim-treesitter" },
      },
    })
    use({
      "jose-elias-alvarez/null-ls.nvim",
      config = function()
        require("plugin-configs.null-ls")
      end,
    })
    use({
      "gbprod/stay-in-place.nvim",
      config = function()
        require("stay-in-place").setup({})
      end,
    })
    use({
      "williamboman/mason.nvim",
      config = function()
        require("plugin-configs.mason")
      end,
    })
    use({ "williamboman/mason-lspconfig.nvim" })

    use({
      "j-hui/fidget.nvim",
      config = function()
        require("plugin-configs.fidget")
      end,
    })
    use({
      "ray-x/lsp_signature.nvim",
    })
    use("folke/lua-dev.nvim")
    use("rafamadriz/friendly-snippets")
    use({
      "L3MON4D3/LuaSnip",
      config = function()
        require("plugin-configs.luasnip")
      end,
    })
    use({
      "hrsh7th/nvim-cmp",
      config = function()
        require("plugin-configs.nvim-cmp")
      end,
      requires = {
        "hrsh7th/cmp-nvim-lsp",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "onsails/lspkind-nvim",
      },
    })
    use({
      "hrsh7th/cmp-cmdline",
      config = function()
        require("plugin-configs.cmp-cmdline")
      end,
    })

    use({
      "honza/dockerfile.vim",
      opt = true,
      ft = { "Dockerfile" },
    })
    use({
      "mustache/vim-mustache-handlebars",
      opt = true,
      ft = { "mustache" },
    })
    use({
      "cespare/vim-toml",
      opt = true,
      ft = { "toml" },
    })
    use({
      "vim-scripts/xml.vim",
      opt = true,
      ft = { "xml" },
    })
    use({
      "cuducos/yaml.nvim",
      ft = { "yaml" }, -- optional
      requires = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-telescope/telescope.nvim", -- optional
      },
    })
    use({
      "pearofducks/ansible-vim",
      opt = true,
      ft = { "yaml", "ansible", "ansible_hosts" },
    })
    use({
      "elzr/vim-json",
      ft = { "json" },
    })
    use({
      "ray-x/go.nvim",
      ft = { "go" },
      config = function()
        require("plugin-configs.go-nvim")
      end,
    })
    use({
      "plasticboy/vim-markdown",
      opt = true,
      ft = { "markdown", "pandoc.markdown", "rmd" },
      config = function()
        require("plugin-configs.vim-markdown")
      end,
    })
    use({
      "gorbit99/codewindow.nvim",
      config = function()
        require("plugin-configs.codewindow")
      end,
    })
    use({
      "iamcco/markdown-preview.nvim",
      opt = true,
      ft = { "markdown", "pandoc.markdown", "rmd" },
      run = "cd app & npm install",
      config = function()
        require("plugin-configs.markdown-preview")
      end,
    })

    use({
      "jtratner/vim-flavored-markdown",
      opt = true,
      ft = { "markdown", "pandoc.markdown", "rmd" },
    })

    use({
      "nelstrom/vim-markdown-folding",
      opt = true,
      ft = { "markdown", "pandoc.markdown", "rmd" },
    })
    use({
      "stevearc/stickybuf.nvim",
      config = function()
        require("plugin-configs.stickybuf")
      end,
    })
    use({
      "stevearc/aerial.nvim",
      config = function()
        require("plugin-configs.aerial")
      end,
    })
    --[[ #######################
     Coding
    ####################### ]]
    use({
      "numToStr/Comment.nvim",
      config = function()
        require("Comment").setup()
      end,
    })
    use({
      "LudoPinelli/comment-box.nvim",
      config = function()
        require("plugin-configs.comment-box")
      end,
    })
    use({
      "lukas-reineke/indent-blankline.nvim",
      config = function()
        require("plugin-configs.indent-blankline")
      end,
    })
    use({
      "lukas-reineke/headlines.nvim",
      commit = "347ef0371451d9bfbf010c6743fb74997b5b9a80",
      config = function()
        require("headlines").setup()
      end,
    })
    use({
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
    })
    use({
      "liuchengxu/vista.vim",
      config = function()
        require("plugin-configs.vista")
      end,
    })

    use({
      "majutsushi/tagbar",
      config = function()
        require("plugin-configs.tagbar")
      end,
    })

    use("towolf/vim-helm")
    use({
      "hashivim/vim-terraform",
      config = function()
        require("plugin-configs.vim-terraform")
      end,
    })

    use("jvirtanen/vim-hcl")

    --[[ #######################
        Writing
        ####################### ]]
    use({
      "reedes/vim-pencil",
      opt = true,
      ft = { "markdown", "text", "tex" },
    })
    use({
      "folke/zen-mode.nvim",
      config = function()
        require("plugin-configs.zen-mode")
      end,
    })
    use({
      "junegunn/Limelight.vim",
      config = function()
        require("plugin-configs.limelight")
      end,
    })
    use({
      "echasnovski/mini.ai",
      config = function()
        require("plugin-configs.mini-ai")
      end,
    })
    use({
      "kylechui/nvim-surround",
      config = function()
        require("plugin-configs.nvim-surround")
      end,
    })
  end,
})

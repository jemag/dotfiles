-- bootstrap packer
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end

execute("packadd packer.nvim")
vim.cmd("autocmd BufWritePost plugins.lua PackerCompile") -- Auto compile when there are changes in plugins.lua

return require("packer").startup({
  function(use)
    -- Packer can manage itself as an optional plugin
    use({ "wbthomason/packer.nvim", opt = true })

    --[[ #######################
     General
    ####################### ]]
    use({
      "luukvbaal/stabilize.nvim",
      config = function()
        require("stabilize").setup()
      end,
    })
    use({
      "anuvyklack/pretty-fold.nvim",
      config = function()
        require("pretty-fold").setup({})
        require("pretty-fold.preview").setup({
          key = 'h',
        })
      end,
    })
    use({
      "google/vim-jsonnet",
    })
    use({
      "svban/YankAssassin.vim",
    })
    use({
      "gbprod/substitute.nvim",
      config = function()
        require("plugin-configs.substitute")
      end,
    })
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
      -- '~/Projects/github-reference/barbar.nvim',
      config = function()
        require("plugin-configs.barbar")
      end,
    })
    use("szw/vim-maximizer")
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
      "Xuyuanp/scrollbar.nvim",
      config = function()
        require("plugin-configs.scrollbar")
      end,
    })
    use({
      "wincent/scalpel",
      config = function()
        require("plugin-configs.scalpel")
      end,
    })
    use("psliwka/vim-smoothie")
    use({
      "DanilaMihailov/beacon.nvim",
      config = function()
        require("plugin-configs.beacon")
      end,
    })
    -- TODO: Restore to folke version once nil fix is merged
    use({
      "folke/which-key.nvim",
    })
    use("honza/vim-snippets")
    use({
      "SirVer/ultisnips",
      config = function()
        require("plugin-configs.ultisnips")
      end,
    })
    use("christoomey/vim-tmux-navigator")
    use({
      "ThePrimeagen/harpoon",
      config = function()
        require("plugin-configs.harpoon")
      end,
    })
    use({
      "brandoncc/telescope-harpoon.nvim",
      config = function()
        require("telescope").load_extension("harpoon")
      end,
      after = { "telescope.nvim", "harpoon" },
    })
    use({
      "voldikss/vim-floaterm",
      config = function()
        require("plugin-configs.vim-floaterm")
      end,
    })
    --[[ use {
      'jlesquembre/nterm.nvim',
      config =
        function()
          require 'nterm.main'.init({
            maps = false,  -- load defaut mappings
            shell = "zsh",
            size = 20,
            direction = "horizontal", -- horizontal or vertical
            popup = 2000,     -- Number of miliseconds to show the info about the commmand. 0 to dissable
            popup_pos = "SE", --  one of "NE" "SE" "SW" "NW"
            autoclose = 0, -- If command is sucesful, close the terminal after that number of miliseconds. 0 to disable
            require('telescope').load_extension('nterm')
          })
        end,
      requires = {'Olical/aniseed'},
    } ]]
    use("voldikss/fzf-floaterm")
    use("airblade/vim-rooter")
    use("wellle/targets.vim")
    use({
      "justinmk/vim-sneak",
      config = function()
        require("plugin-configs.vim-sneak")
      end,
    })
    use({
      "airblade/vim-current-search-match",
      config = function()
        vim.g.current_search_match = "IncSearch"
      end,
    })
    use({
      "phaazon/hop.nvim",
      as = "hop",
      config = function()
        -- you can configure Hop the way you like here; see :h hop-config
        require("plugin-configs.hop")
      end,
    })
    use({
      "hrsh7th/vim-searchx",
      config = function()
        vim.cmd("source ~/.config/nvim/plugin-configs/vim-searchx.vim")
      end,
    })
    --[[ use {
      'chentau/marks.nvim',
      config = function() require"marks".setup{} end
    } ]]
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
      "nvim-telescope/telescope-ui-select.nvim",
      after = { "telescope.nvim" },
      config = function()
        require("telescope").load_extension("ui-select")
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
      "kyazdani42/nvim-tree.lua",
      config = function()
        require("plugin-configs.nvim-tree")
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
    use("gerw/vim-HiLinkTrace")
    use({
      "gennaro-tedesco/nvim-peekup",
      config = function()
        require("plugin-configs.nvim-peekup")
      end,
    })

    -- Themes
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
    use("Pocco81/Catppuccino.nvim")
    use({
      "EdenEast/nightfox.nvim",
    })
    use({
      "lourenci/github-colors",
    })
    use({
      "eddyekofo94/gruvbox-flat.nvim",
      config = function()
        vim.g.gruvbox_flat_style = "dark"
      end,
    })
    use("folke/lsp-colors.nvim")
    use("cocopon/iceberg.vim")
    use("sainnhe/sonokai")
    use({
      "Shatur95/neovim-ayu",
      -- setup = function() vim.g.ayu_mirage = true end
    })
    use("doums/darcula")
    use({ "briones-gabriel/darcula-solid.nvim", requires = "rktjmp/lush.nvim" })
    use("aonemd/kuroi.vim")
    use("romgrk/doom-one.vim")
    --TODO: restore when we figure a way to deal with their gruvbox theme and the community one
    -- use 'ChristianChiarulli/nvcode-color-schemes.vim'
    use("habamax/vim-gruvbit")
    use("kyazdani42/blue-moon")
    use("romainl/Apprentice")
    use("drewtempelmeyer/palenight.vim")
    use("heraldofsolace/nisha-vim")
    use("ghifarit53/tokyonight-vim")
    use({
      "chuling/equinusocio-material.vim",
      config = function()
        require("plugin-configs.equinusocio-material")
      end,
    })
    use("gruvbox-community/gruvbox")
    use("shaunsingh/nord.nvim")
    use("mhartington/oceanic-next")
    use("franbach/miramare")
    use("chuling/ci_dark")
    use({
      "sonph/onehalf",
      rtp = "vim",
    })
    use("joshdick/onedark.vim")
    use("fnune/base16-vim")
    use({
      "folke/tokyonight.nvim",
      config = function()
        vim.g.tokyonight_style = "storm"
      end,
    })
    use("shaunsingh/moonlight.nvim")
    --[[ #######################
     Plugin development
    ####################### ]]
    use("nvim-lua/plenary.nvim")

    --[[ #######################
     Interface
    ####################### ]]
    use("kyazdani42/nvim-web-devicons")

    use({
      "norcalli/nvim-colorizer.lua",
    })

    use({
      "ludovicchabant/vim-gutentags",
      config = function()
        require("plugin-configs.vim-gutentags")
      end,
    })

    use({
      "mhinz/vim-startify",
      config = function()
        require("plugin-configs.startify")
      end,
    })

    use({
      "rmagatti/auto-session",
      config = function()
        require("plugin-configs.auto-session")
      end,
    })

    use({
      "rmagatti/session-lens",
      config = function()
        require("plugin-configs.session-lens")
      end,
      after = { "telescope.nvim", "auto-session" },
    })

    use("junegunn/vim-easy-align")

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

    use("vijaymarupudi/nvim-fzf")

    use("nvim-lua/popup.nvim")
    use("nvim-telescope/telescope-fzy-native.nvim")
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
    use("tpope/vim-fugitive")
    use({
      "sindrets/diffview.nvim",
      config = function()
        require("plugin-configs.diffview")
      end,
    })
    use({
      "pwntester/octo.nvim",
      config = function()
        require("octo").setup()
      end,
    })
    use("junegunn/gv.vim")
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
      "b0o/schemastore.nvim",
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
      "weilbith/nvim-code-action-menu",
      cmd = "CodeActionMenu",
    })
    use({
      "williamboman/nvim-lsp-installer",
    })
    use({
      "ray-x/lsp_signature.nvim",
      config = function()
        require("plugin-configs.lsp_signature")
      end,
      commit = "be39dacc17d51531f9e3a50f88de0a45683c6634",
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
      "Vimjas/vim-python-pep8-indent",
      opt = true,
      ft = { "python" },
    })
    use({
      "vim-python/python-syntax",
      opt = true,
      ft = { "python" },
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
    --[[ use {
      'fatih/vim-go',
      opt = true,
      ft = {'go', 'yaml'},
      config = function () require 'plugin-configs.vim-go' end
    } ]]
    use({
      "plasticboy/vim-markdown",
      opt = true,
      ft = { "markdown", "pandoc.markdown", "rmd" },
      config = function()
        require("plugin-configs.vim-markdown")
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

    -- TODO: Enable again once nil fix is merged
    --[[ use({
      "simrat39/symbols-outline.nvim",
      config = function()
        require("plugin-configs.symbols-outline")
      end,
    }) ]]
    --[[ #######################
     Coding
    ####################### ]]
    use("b3nj5m1n/kommentary")

    use({
      "Chiel92/vim-autoformat",
      opt = true,
      cmd = "Autoformat",
    })

    use({
      "lukas-reineke/indent-blankline.nvim",
      config = function()
        require("plugin-configs.indent-blankline")
      end,
    })
    use({
      "lukas-reineke/headlines.nvim",
      config = function()
        require("headlines").setup()
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

    use({
      "andrewstuart/vim-kubernetes",
      opt = true,
      ft = { "yaml" },
    })

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
      "junegunn/goyo.vim",
      config = function()
        vim.cmd("source ~/.config/nvim/plugin-configs/goyo.vim")
      end,
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

    -- TextObjectOperator
    use("tpope/vim-surround")
  end,
})

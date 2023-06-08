require("nvim-treesitter.configs").setup({
  indent = {
    enable = false,
  },
  highlight = {
    enable = true, -- false will disable the whole extension
    additional_vim_regex_highlighting = false,
  },
  autopairs = { enable = true },
  incremental_selection = {
    enable = true,
    disable = { "phpdoc" },
    keymaps = { -- mappings for incremental selection (visual mappings)
      init_selection = "<cr>", -- maps in normal mode to init the node/scope selection
      node_incremental = "<cr>", -- increment to the upper named parent
      scope_incremental = "grc", -- increment to the upper scope (as defined in locals.scm)
      node_decremental = "<bs>", -- decrement to the previous node
    },
  },
  refactor = {
    highlight_definitions = {
      enable = false,
    },
    highlight_current_scope = {
      enable = false,
    },
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = "grr", -- mapping to rename reference under cursor
      },
    },
    navigation = {
      enable = true,
      keymaps = {
        goto_definition = "gnd", -- mapping to go to definition of symbol under cursor
        list_definitions = "gnD", -- mapping to list all definitions in current file
      },
    },
  },
  rainbow = {
    enable = true,
    -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = 10000, -- Do not enable for files with more than n lines, int
    -- colors = {}, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
  },
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        -- function
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        -- o for object (classes)
        ["ao"] = "@class.outer",
        ["io"] = "@class.inner",
        -- conditional
        ["ac"] = "@conditional.outer",
        ["ic"] = "@conditional.inner",
        -- block
        ["ae"] = "@block.outer",
        ["ie"] = "@block.inner",
        -- loop
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
        -- a for argument
        -- now handled through miniai to support count
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        -- statement
        ["as"] = "@statement.outer",
        -- comment
        ["aC"] = "@comment.outer",
        -- m for method call
        ["am"] = "@call.outer",
        ["im"] = "@call.inner",
      },
    },
  },
  ensure_installed = {
    "bash",
    "bibtex",
    "c",
    "c_sharp",
    "clojure",
    "cmake",
    -- May have slow performance in large files
    -- "comment",
    "commonlisp",
    "cpp",
    "css",
    "cuda",
    "d",
    "dart",
    "devicetree",
    "dockerfile",
    "elixir",
    "elm",
    "erlang",
    "fennel",
    "fish",
    "foam",
    "fortran",
    "gdscript",
    "go",
    "gomod",
    "gowork",
    "graphql",
    "haskell",
    "hcl",
    "heex",
    "hjson",
    "html",
    "http",
    "java",
    "javascript",
    "jsdoc",
    "json",
    "jsonnet",
    "json5",
    "jsonc",
    "julia",
    "kotlin",
    "latex",
    "llvm",
    "lua",
    "make",
    "markdown",
    "markdown_inline",
    "ninja",
    "nix",
    "norg",
    "ocaml",
    "ocaml_interface",
    "ocamllex",
    "pascal",
    "perl",
    "python",
    "ql",
    "query",
    "r",
    "rasi",
    "regex",
    "rego",
    "rst",
    "ruby",
    "rust",
    "scala",
    "scheme",
    "scss",
    "solidity",
    "svelte",
    "swift",
    "teal",
    "todotxt",
    "toml",
    "tsx",
    "typescript",
    "vala",
    "vim",
    "vimdoc",
    "vue",
    "yaml",
  }, -- one of "all", "language", or a list of languages
})

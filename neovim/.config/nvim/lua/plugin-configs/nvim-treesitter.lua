local ensure_installed = {
  "bash",
  "bibtex",
  "bicep",
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
  "diff",
  "devicetree",
  "dockerfile",
  "elixir",
  "elm",
  "erlang",
  "fennel",
  "fish",
  "foam",
  "fortran",
  "gitcommit",
  "gitignore",
  "git_rebase",
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
  "ini",
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
  "luap",
  "luadoc",
  "make",
  "markdown",
  "markdown_inline",
  "ninja",
  "nix",
  "norg",
  "nu",
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
  "tmux",
  "tsx",
  "typescript",
  "typst",
  "vala",
  "vim",
  "vimdoc",
  "vue",
  "yaml",
} -- one of "all", "language", or a list of languages

local already_installed = require("nvim-treesitter").get_installed()
local parsers_to_install = vim
  .iter(ensure_installed)
  :filter(function(parser)
    return not vim.tbl_contains(already_installed, parser)
  end)
  :totable()

require("nvim-treesitter").install(parsers_to_install)

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start) -- errors for filetypes with no parser
  end,
  desc = "Enable treesitter highlighting",
})

require("nvim-treesitter").setup({
  -- autopairs = { enable = true },
  -- incremental_selection = {
  --   enable = true,
  --   disable = { "phpdoc" },
  --   keymaps = { -- mappings for incremental selection (visual mappings)
  --     node_incremental = "v", -- increment to the upper named parent
  --     scope_incremental = "grc", -- increment to the upper scope (as defined in locals.scm)
  --     node_decremental = "V", -- decrement to the previous node
  --   },
  -- },
  -- refactor = {
  --   highlight_definitions = {
  --     enable = false,
  --   },
  --   highlight_current_scope = {
  --     enable = false,
  --   },
  --   smart_rename = {
  --     enable = true,
  --     keymaps = {
  --       smart_rename = "grr", -- mapping to rename reference under cursor
  --     },
  --   },
  --   navigation = {
  --     enable = true,
  --     keymaps = {
  --       goto_definition = "gnd", -- mapping to go to definition of symbol under cursor
  --       list_definitions = "gnD", -- mapping to list all definitions in current file
  --     },
  --   },
  -- },
  -- textobjects = {
  --   select = {
  --     enable = true,
  --     -- Automatically jump forward to textobj, similar to targets.vim
  --     lookahead = true,
  --     keymaps = {
  --       -- You can use the capture groups defined in textobjects.scm
  --       -- function
  --       ["af"] = "@function.outer",
  --       ["if"] = "@function.inner",
  --       -- o for object (classes)
  --       ["ao"] = "@class.outer",
  --       ["io"] = "@class.inner",
  --       -- conditional
  --       ["ac"] = "@conditional.outer",
  --       ["ic"] = "@conditional.inner",
  --       -- block
  --       ["ae"] = "@block.outer",
  --       ["ie"] = "@block.inner",
  --       -- loop
  --       ["al"] = "@loop.outer",
  --       ["il"] = "@loop.inner",
  --       -- a for argument
  --       -- now handled through miniai to support count
  --       ["aa"] = "@parameter.outer",
  --       ["ia"] = "@parameter.inner",
  --       -- statement
  --       ["as"] = "@statement.outer",
  --       -- comment
  --       ["ak"] = "@comment.outer",
  --       -- m for method call
  --       ["am"] = "@call.outer",
  --       ["im"] = "@call.inner",
  --     },
  --   },
  --   move = {
  --     enable = true,
  --     set_jumps = true, -- whether to set jumps in the jumplist
  --     goto_next_start = {
  --       ["]f"] = "@function.outer",
  --       ["]o"] = "@class.outer",
  --       ["]a"] = "@parameter.inner",
  --     },
  --     goto_previous_start = {
  --       ["[f"] = "@function.outer",
  --       ["[o"] = "@class.outer",
  --       ["[a"] = "@parameter.inner",
  --     },
  --     goto_next_end = {
  --       ["]F"] = "@function.outer",
  --       ["]O"] = "@class.outer",
  --       ["]A"] = "@parameter.inner",
  --     },
  --     goto_previous_end = {
  --       ["[F"] = "@function.outer",
  --       ["[O"] = "@class.outer",
  --       ["[A"] = "@parameter.inner",
  --     },
  --   },
  -- },
})

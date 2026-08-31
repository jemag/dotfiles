-- Go debugging, without `leoluz/nvim-dap-go`.
--
-- The plugin injected seven configurations we could not opt out of, two of which
-- were broken: `Debug test` used `program = "${file}"` (delve needs a *package
-- directory* in `mode = "test"`; given one file, Go compiles it as a synthetic
-- `command-line-arguments` package and every other symbol becomes `undefined: X`),
-- and `Debug test (go.mod)` used the cwd-relative `./${relativeFileDirname}`, which
-- only resolves when Neovim was started from the module root.
--
-- Nearest-test debugging lives in neotest-golang (`<localleader>nD`), so there is no
-- treesitter test detection here.

local dap = require("dap")

-- `dlv` comes from Nix (nix/modules/home-manager/cli.nix). nvim-dap fills in
-- `${port}` and spawns the process itself.
--
-- This must be a *function*, not a table. Delve runs the `go test -c` build step in
-- the working directory of its own process, not in the launch config's `cwd`, so a
-- static adapter inherits Neovim's cwd and dies with "go.mod file not found in
-- current directory or any parent directory" whenever nvim was not started from
-- inside the module. nvim-dap expands `${fileDirname}` and friends in
-- `prepare_config` *before* calling the adapter function, so `config.cwd` is already
-- an absolute path here.
dap.adapters.go = function(callback, config)
  callback({
    type = "server",
    port = "${port}",
    executable = {
      command = "dlv",
      args = { "dap", "-l", "127.0.0.1:${port}" },
      cwd = config.cwd,
    },
    options = {
      initialize_timeout_sec = 20,
    },
  })
end

local function prompt_args()
  return require("dap.utils").splitstr(vim.fn.input("Arguments: "))
end

-- Assigned outright rather than appended, so re-sourcing this file cannot
-- accumulate duplicates. Every path is absolute (`${file}` / `${fileDirname}`) and
-- so is independent of Neovim's cwd. `outputMode = "remote"` routes the program's
-- stdout through DAP into the dap-ui `console` element instead of a hidden terminal.
dap.configurations.go = {
  {
    type = "go",
    name = "Debug file",
    request = "launch",
    program = "${file}",
    cwd = "${fileDirname}",
    outputMode = "remote",
  },
  {
    type = "go",
    name = "Debug package",
    request = "launch",
    program = "${fileDirname}",
    cwd = "${fileDirname}",
    outputMode = "remote",
  },
  {
    type = "go",
    name = "Debug package (args)",
    request = "launch",
    program = "${fileDirname}",
    cwd = "${fileDirname}",
    args = prompt_args,
    outputMode = "remote",
  },
  {
    type = "go",
    name = "Debug test (package)",
    request = "launch",
    mode = "test",
    program = "${fileDirname}",
    cwd = "${fileDirname}",
    outputMode = "remote",
  },
  {
    type = "go",
    name = "Attach to process",
    request = "attach",
    mode = "local",
    processId = function()
      return require("dap.utils").pick_process()
    end,
  },
}

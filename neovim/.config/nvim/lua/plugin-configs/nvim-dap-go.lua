local dap = require("dap")

require("dap-go").setup({
  dap_configurations = {
    -- `mode = "test"` requires a *package directory*, never a single file.
    -- `${fileDirname}` is absolute, so this works regardless of Neovim's cwd
    -- (unlike dap-go's built-in "Debug test (go.mod)", which uses the
    -- cwd-relative `./${relativeFileDirname}` and only works from the module root).
    {
      type = "go",
      name = "Debug test (package)",
      request = "launch",
      mode = "test",
      program = "${fileDirname}",
      cwd = "${fileDirname}",
      outputMode = "remote",
    },
  },
})

-- Remove dap-go's built-in "Debug test" configuration. It uses
-- `program = "${file}"`, which makes delve run `go test -c <file>.go`. Go then
-- compiles that single file as a synthetic `command-line-arguments` package, so
-- every symbol defined elsewhere in the real package fails with "undefined: X"
-- and the launch aborts with a bare "Failed to launch".
for i = #(dap.configurations.go or {}), 1, -1 do
  if dap.configurations.go[i].name == "Debug test" then
    table.remove(dap.configurations.go, i)
  end
end

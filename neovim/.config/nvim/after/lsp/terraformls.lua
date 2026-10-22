-- Read provider schemas from .terragrunt-cache so go-to-definition works on
-- provider resources (see nix/pkgs/terraform-ls-terragrunt-shim.nix).
local shim = vim.fn.exepath("terraform-ls-terragrunt-shim")

return {
  init_options = shim ~= "" and { terraform = { path = shim } } or nil,
}

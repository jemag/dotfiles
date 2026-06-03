{ pkgs }:
{
  javaLspScript = import ./java-lsp-script.nix { inherit pkgs; };
  opencode-model-router = import ./opencode-model-router.nix { inherit pkgs; };
}

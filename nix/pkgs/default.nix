{ pkgs }:
{
  javaLspScript = import ./java-lsp-script.nix { inherit pkgs; };
}

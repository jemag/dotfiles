{ lib, config, pkgs, ... }:
let cfg = config.cli;
in
{
  options = {
    cli.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable CLI programs";
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    #config contents
    home.packages = with pkgs; [
      bat
      ticker
      tmuxinator
      redshift
      rustup
      nixfmt-classic
      nix-search-cli # search nixpkgs
      manix # search nix options
      nix-tree # browse dependency graphs of Nix derivations
      nix-health # check health of nix installation
    ];
  };
}

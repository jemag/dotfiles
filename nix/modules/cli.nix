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
      eza
      btop
      dig
      difftastic
      fzf
      fd
      falcoctl
      gh
      lazygit
      delta
      manix # search nix options
      nix-health # check health of nix installation
      nix-search-cli # search nixpkgs
      nix-tree # browse dependency graphs of Nix derivations
      nixfmt-classic
      rustup
      ticker
      tmux
      tmuxinator
      zsh-forgit
    ];
  };
}

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
      btop
      delta
      difftastic
      dig
      eza
      falcoctl
      fd
      fzf
      gh
      glow
      go
      gobuster
      gradle
      helix
      htop
      ijq
      imagemagick
      jdk17
      jdk22
      jq
      lazygit
      manix # search nix options
      nix-health # check health of nix installation
      nix-search-cli # search nixpkgs
      nix-tree # browse dependency graphs of Nix derivations
      nixfmt-classic
      rustup
      socat
      ticker
      tmux
      tmuxinator
      yq-go
      zsh-forgit
    ];
  };
}

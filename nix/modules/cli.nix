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

    programs = {

      gh = {
        enable = true;
        settings = {
          editor = "nvim";
          git_protocol = "ssh";
          browser = "xdg-open";
          aliases = {
            co = "pr checkout";

          };
        };
      };

      bat = {
        enable = true;
        config = {
          pager =
            "less --RAW-CONTROL-CHARS --quit-if-one-screen --mouse --ignore-case";
        };
      };

    };
    home = {

      file = {
        ".config/.ripgreprc" = {
          source = config.lib.file.mkOutOfStoreSymlink
            "${config.home.homeDirectory}/dotfiles/ripgrep/.config/.ripgreprc";
        };
        ".config/delta/themes/themes.gitconfig" = {
          source = config.lib.file.mkOutOfStoreSymlink
            "${config.home.homeDirectory}/dotfiles/delta/.config/delta/themes/themes.gitconfig";
        };
        ".config/dive/dive.yaml" = {
          source = config.lib.file.mkOutOfStoreSymlink
            "${config.home.homeDirectory}/dotfiles/dive/.config/dive/dive.yaml";
        };
      };

      packages = with pkgs; [
        bat
        btop
        delta
        difftastic
        dig
        dust
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
        jdk22
        jq
        lazygit
        manix # search nix options
        nix-health # check health of nix installation
        nix-search-cli # search nixpkgs
        nix-tree # browse dependency graphs of Nix derivations
        nixfmt-classic
        parallel
        ripgrep
        rustup
        socat
        starship
        stow
        tealdeer
        thefuck
        ticker
        tmux
        tmuxinator
        tree-sitter
        unzip
        viddy
        whois
        yamllint
        yazi
        yq-go
        zellij
        zoxide
        zsh-forgit
      ];

    };
  };
}

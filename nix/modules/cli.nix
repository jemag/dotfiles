{ lib, config, pkgs, ... }:
let cfg = config.cli;
in {
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

      neovim = {
        enable = true;
        #NOTE: currently missing vscode-html-languageserver (html lsp)
        extraPackages = with pkgs; [
          angular-language-server
          ansible-language-server
          bash-language-server
          bicep-lsp
          clang-tools # contains clangd
          dockerfile-language-server-nodejs
          gopls
          helm-ls
          jdt-language-server
          jsonnet-language-server
          lua-language-server
          marksman
          nixd
          rust-analyzer
          terraform-ls
          tinymist
          typescript-language-server
          vscode-json-languageserver
          yaml-language-server
        ];
      };

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

      man = {
        enable = true;
        generateCaches = true;
      };

      java = {
        enable = true;
        package = pkgs.jdk21;
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
        ".config/git/config" = {
          source = config.lib.file.mkOutOfStoreSymlink
            "${config.home.homeDirectory}/dotfiles/git/.config/git/config";
        };
        ".kube/kubie.yaml" = {
          source = config.lib.file.mkOutOfStoreSymlink
            "${config.home.homeDirectory}/dotfiles/kubie/.kube/kubie.yaml";
        };
      };

      packages = with pkgs; [
        aider-chat
        bat
        bash
        btop
        cachix
        carapace
        cmake
        delta
        devbox
        difftastic
        dig
        duf
        dust
        entr
        eza
        fd
        fx
        fzf
        gh
        ghostscript
        gh-dash
        glow
        go
        gobuster
        gradle
        grafana-alloy
        helix
        hurl
        htop
        isort
        ijq
        ipcalc
        iperf
        imagemagick
        iotop-c
        jq
        jqp
        k9s
        k3d
        kind
        krew
        kube-linter
        kubecolor
        kubeconform
        kubectl
        kubectx
        kubelogin
        kubent
        kubernetes-helm
        kubeshark
        kubie
        kustomize
        kyverno
        lazygit
        manix # search nix options
        mermaid-cli
        mkcert
        nh
        netmask
        nix-health # check health of nix installation
        nix-search-cli # search nixpkgs
        nix-tree # browse dependency graphs of Nix derivations
        nixfmt-classic
        nodejs
        nushell
        nufmt
        parallel
        ripgrep
        rustup
        sesh
        smassh
        socat
        starship
        stow
        stylua
        tealdeer
        # tectonic
        ticker
        # xml formatter
        html-tidy
        tcpdump
        termshark
        tshark
        tmux
        tmuxinator
        tokei
        tree-sitter
        trivy
        unzip
        velero
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

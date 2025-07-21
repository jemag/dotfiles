{ lib, config, pkgs, ... }:
let
  cfg = config.cli;
  myPkgs = import ../pkgs { inherit pkgs; };
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
        extraPackages = with pkgs; [
          # language servers
          angular-language-server
          ansible-language-server
          bash-language-server
          bicep-lsp
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
          vscode-langservers-extracted
          yaml-language-server
          golangci-lint-langserver
          solargraph
          vim-language-server
          # others
          vscode-extensions.vscjava.vscode-java-debug
          vscode-extensions.vscjava.vscode-java-test
          # linters/formatters
          black
          delve
          editorconfig-checker
          gofumpt
          gotools
          golangci-lint
          golines
          gomodifytags
          gotests
          gotestsum
          iferr
          impl
          pyright
          shfmt
          yamlfmt
          yamllint
          lombok
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
        ".config/tmuxinator" = {
          source = config.lib.file.mkOutOfStoreSymlink
            "${config.home.homeDirectory}/dotfiles/tmuxinator/.config/tmuxinator";
        };
        ".config/yamlfmt" = {
          source = config.lib.file.mkOutOfStoreSymlink
            "${config.home.homeDirectory}/dotfiles/yamlfmt/.config/yamlfmt";
        };
        ".config/zsh" = {
          source = config.lib.file.mkOutOfStoreSymlink
            "${config.home.homeDirectory}/dotfiles/zsh/.config/zsh";
        };
        ".config/starship.toml" = {
          source = config.lib.file.mkOutOfStoreSymlink
            "${config.home.homeDirectory}/dotfiles/zsh/.config/starship.toml";
        };
        ".config/ticker" = {
          source = config.lib.file.mkOutOfStoreSymlink
            "${config.home.homeDirectory}/dotfiles/ticker/.config/ticker";
        };
        ".config/stylua.toml" = {
          source = config.lib.file.mkOutOfStoreSymlink
            "${config.home.homeDirectory}/dotfiles/stylua/.config/stylua.toml";
        };
        ".config/nvim" = {
          source = config.lib.file.mkOutOfStoreSymlink
            "${config.home.homeDirectory}/dotfiles/neovim/.config/nvim";
        };
      };

      packages = with pkgs;
        builtins.attrValues myPkgs ++ [
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
          dotnet-aspnetcore
          prettier
          stylua
          tflint
          yamlfmt
          yamllint
          clang-tools # contains clangd
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
          inotify-tools # for nvim lsp performance
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
          lua5_1
          luarocks
          python3
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
          opencode
          parallel
          ripgrep
          ruby
          rustup
          sesh
          smassh
          sqlite
          socat
          starship
          stow
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

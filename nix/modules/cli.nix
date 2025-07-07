{ lib, config, pkgs, ... }:
let
  cfg = config.cli;
  javaLspScript = pkgs.writeShellScriptBin "javaLspScript" ''
    set -ev
    JDTLS_CONFIG_DIR=~/jdtls-config
    mkdir -p $JDTLS_CONFIG_DIR
    cp -r ${pkgs.jdt-language-server}/share/java/jdtls/config_linux/* $JDTLS_CONFIG_DIR/
    chmod -R 755 $JDTLS_CONFIG_DIR

    java \
    -Declipse.application=org.eclipse.jdt.ls.core.id1 \
    -Dosgi.bundles.defaultStartLevel=4 \
    -Declipse.product=org.eclipse.jdt.ls.core.product \
    -Dlog.protocol=true \
    -Dlog.level=ALL \
    -javaagent:"${pkgs.lombok}/share/java/lombok.jar" \
    -Xms1g \
    --add-modules=ALL-SYSTEM \
    --add-opens \
    java.base/java.util=ALL-UNNAMED \
    --add-opens \
    java.base/java.lang=ALL-UNNAMED \
    -jar ${pkgs.jdt-language-server}/share/java/jdtls/plugins/org.eclipse.equinox.launcher_*.jar \
    -configuration $JDTLS_CONFIG_DIR \
    -data \
    ~/workspace/
  '';
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
          # vscode-json-languageserver
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
      };

      packages = with pkgs; [
        aider-chat
        bat
        javaLspScript
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

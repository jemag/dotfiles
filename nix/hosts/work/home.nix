{ lib, config, pkgs, ... }:

{
  imports = [ ../../modules/cli.nix ../../modules/gui.nix ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home = {

    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    username = "jemag";
    homeDirectory = "/home/jemag";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "24.05"; # Please read the comment before changing.

    # The home.packages option allows you to install Nix packages into your
    # environment.
    packages = with pkgs; [
      argocd
      (azure-cli.withExtensions [
        azure-cli.extensions.azure-devops
        azure-cli.extensions.fzf
      ])
      cyclonedx-cli
      syft
      azure-storage-azcopy
      # azure-storage-azcopy
      buildkit
      calicoctl
      cilium-cli
      # Note: temporarily disabled due to cyclonedx-python-lib issue
      # checkov
      memcached
      cmctl
      # cosign
      cri-tools
      dockle
      falcoctl
      grafana-loki
      hubble
      jfrog-cli
      maven
      pack
      powershell
      radare2
      skopeo
      sonar-scanner-cli
      step-cli
      swaks # Swiss Army Knife for SMTP testing
      terraform
      terragrunt
      tflint
      # # Adds the 'hello' command to your environment. It prints a friendly
      # # "Hello, world!" when run.

      # # It is sometimes useful to fine-tune packages, for example, by applying
      # # overrides. You can do that directly here, just don't forget the
      # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # # fonts?
      # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    file = {
        ".zshrc" = {
          source = config.lib.file.mkOutOfStoreSymlink
            "${config.home.homeDirectory}/dotfiles/zsh-wsl/.zshrc";
        };
        ".zshenv" = {
          source = config.lib.file.mkOutOfStoreSymlink
            "${config.home.homeDirectory}/dotfiles/zsh-wsl/.zshenv";
        };
        ".config/zsh" = {
          source = config.lib.file.mkOutOfStoreSymlink
            "${config.home.homeDirectory}/dotfiles/zsh-wsl/.config/zsh";
        };
        ".config/paru" = {
          source = config.lib.file.mkOutOfStoreSymlink
            "${config.home.homeDirectory}/dotfiles/paru/.config/paru";
        };
        ".config/powershell" = {
          source = config.lib.file.mkOutOfStoreSymlink
            "${config.home.homeDirectory}/dotfiles/powershell/.config/powershell";
        };
    };

    # Home Manager can also manage your environment variables through
    # 'home.sessionVariables'. These will be explicitly sourced when using a
    # shell provided by Home Manager. If you don't want to manage your shell
    # through Home Manager then you have to manually source 'hm-session-vars.sh'
    # located at either
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  /etc/profiles/per-user/jemag/etc/profile.d/hm-session-vars.sh
    #
    sessionVariables = {
      # EDITOR = "vi";
    };
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager = { enable = true; };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };

  };
}

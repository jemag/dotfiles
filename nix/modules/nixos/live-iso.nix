{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.liveIso = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable live ISO specific configuration";
    };
  };

  config = lib.mkIf config.liveIso.enable {
    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';

    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.supportedFilesystems.zfs = lib.mkForce false;

    networking.hostName = "live-iso";
    networking.networkmanager.enable = true;

    time.timeZone = "America/New_York";

    i18n.defaultLocale = "en_US.UTF-8";

    users.users.jemag = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };

    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;

    environment.systemPackages = with pkgs; [
      vim
      bash
      zsh
      gnumake
      gcc
      autoconf
      automake
      libtool
      git
      bitwarden-cli
      openssh
      wget
      curl
      eza
      fzf
      ripgrep
      jq
      htop
      tree
      unzip
    ];

    services.openssh.enable = true;

    nixpkgs.config.allowUnfree = true;
  };
}

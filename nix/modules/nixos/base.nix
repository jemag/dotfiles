{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.base = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable base NixOS configuration shared across all hosts";
    };
  };

  config = lib.mkIf config.base.enable {
    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';
    nix.settings = {
      trusted-users = [ "jemag" ];
      auto-optimise-store = true;
    };

    nix.gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than +5";
    };

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.configurationLimit = 10;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot";

    # Use latest kernel.
    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.supportedFilesystems.zfs = lib.mkForce false;

    networking.networkmanager.enable = true;

    time.timeZone = "America/New_York";

    i18n.defaultLocale = "en_US.UTF-8";

    systemd.targets.sleep.enable = false;
    systemd.targets.suspend.enable = false;
    systemd.targets.hibernate.enable = false;
    systemd.targets.hybrid-sleep.enable = false;

    services.logind.settings.Login = {
      IdleAction = "ignore";
      IdleActionSec = 0;
    };

    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };

    users.users.jemag = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      packages = with pkgs; [ tree ];
    };

    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    fonts.packages = with pkgs; [
      fira-code
      fira
      jetbrains-mono
      fira-code-symbols
    ];

    services.openssh.enable = true;

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      vim
      bash
      git
      bitwarden-cli
      jq
    ];

    system.stateVersion = "25.05";
  };
}

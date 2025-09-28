# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

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

  boot.kernel.sysctl = {
    "net.ipv6.conf.all.disable_ipv6" = true;
    "net.ipv6.conf.default.disable_ipv6" = true;
    "net.ipv6.conf.lo.disable_ipv6" = true;
  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "amd_pstate=disable" # not supported by 3700x
  ];
  boot.supportedFilesystems.zfs = lib.mkForce false;

  networking.hostName = "desktop"; # Define your hostname.
  # Pick only one of the below networking options.
  networking.wireless.enable =
    false; # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable =
    true; # Easiest to use and most distros use this by default.
  networking.networkmanager.ensureProfiles.profiles = {
    "wired-1" = {
      connection.type = "ethernet";
      connection.id = "wired-1";
      connection.interface-name =
        "enp39s0"; # Make sure this matches your interface
      connection.autoconnect = true;

      ipv4.method = "manual";
      ipv4.addresses = "192.168.1.112/24";
      ipv4.gateway = "192.168.1.254";
      # ipv4.dns = "8.8.8.8";
    };
  };
  networking.enableIPv6 = false;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # systemd.user.services.spice-vdagent-client = {
  #   description = "Spice VDAgent Client";
  #   wantedBy = [ "graphical-session.target" ];
  #   serviceConfig = {
  #     ExecStart = "${pkgs.spice-vdagent}/bin/spice-vdagent-client";
  #     Restart = "on-failure";
  #     RestartSec = 5;
  #   };
  # };
  # systemd.user.services.spice-vdagent-client.enable = true;
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  services.logind.settings.Login = {
    IdleAction = "ignore";
    IdleActionSec = 0;
  };

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jemag = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [ tree ];
  };

  # programs.firefox.enable = true;
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  programs.steam = { enable = true; };
  programs.sway = {
    enable = true;
    extraOptions = [ "--unsupported-gpu" ];
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      gnome-keyring
      swaylock
      swayidle
      wl-clipboard
      wf-recorder
      xwayland
      mako
      libnotify
      grim
      slurp
      dmenu
      rofi
      wmenu
      foot
    ];
  };
  programs.waybar.enable = true;

  virtualisation.docker = { enable = true; };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    bash
    killall
    gnumake
    gcc
    autoconf
    automake
    libtool
    mesa
    git
    wezterm
    vlc
    wget
  ];
  services.displayManager.gdm.enable = true;

  nixpkgs.config.allowUnfree = true;

  # NOTE: password for the user must be configured using smbpasswd -a jemag
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    settings = {
      global = {
        workgroup = "WORKGROUP";
        "invalid users" = [ "root" ];
        "passwd program" = "/run/wrappers/bin/passwd %u";
        security = "user";
        "guest ok" = "no";
      };
      jemag = {
        browseable = "yes";
        comment = "Home directories";
        path = "/home/jemag";
        "read only" = "yes";
        "valid users" = "jemag";
      };
    };
  };
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    open = false;
  };
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  xdg.portal = {
    config = {
      sway = { "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ]; };
    };
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
    ];
    wlr.enable = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;
  networking.firewall.allowPing = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}


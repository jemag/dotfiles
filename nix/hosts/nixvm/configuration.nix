{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/base.nix
  ];

  networking.hostName = "nixvm"; # Define your hostname.
  systemd.network.enable = false;

  boot.kernelParams = [
    "preempt=full"
    "zswap.enabled=1" # enables zswap
    "zswap.compressor=zstd" # compression algorithm
    "zswap.max_pool_percent=20" # maximum percentage of RAM that zswap is allowed to use
    "zswap.shrinker_enabled=1" # whether to shrink the pool proactively on high memory pressure
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;

  users.users.jemag.extraGroups = [
    "wheel"
    "docker"
    "render"
    "video"
    "libvirtd"
  ];

  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;

  programs.steam.enable = true;
  programs.sway = {
    enable = true;
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

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    dnsmasq
    killall
    gnumake
    gcc
    autoconf
    automake
    libtool
    mesa
    mullvad-vpn
    mullvad-browser
    kdePackages.dolphin
    wezterm
    vlc
    wget
  ];

  environment.etc."xdg/menus/applications.menu".source =
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  services.displayManager.gdm.enable = true;
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  xdg.portal = {
    config = {
      sway = {
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };
    };
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
    ];
    wlr.enable = true;
  };

  networking.firewall.enable = true;
}

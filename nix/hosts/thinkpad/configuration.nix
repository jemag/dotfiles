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

  networking.hostName = "thinkpad";

  boot.kernel.sysctl = {
    "net.ipv6.conf.all.disable_ipv6" = true;
    "net.ipv6.conf.default.disable_ipv6" = true;
    "net.ipv6.conf.lo.disable_ipv6" = true;
  };

  networking.wireless.enable = false;
  networking.enableIPv6 = false;

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
      grim
      slurp
      dmenu
      rofi
      wmenu
      foot
    ];
  };
  programs.waybar.enable = true;

  environment.systemPackages = with pkgs; [
    killall
    gnumake
    gcc
    autoconf
    automake
    libtool
    mesa
    spice-vdagent
    wezterm
    vlc
    wget
  ];

  services.displayManager.gdm.enable = true;

  services.xserver.videoDrivers = [ "intel" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-vaapi-driver
      libvdpau-va-gl
      intel-media-driver
    ];
  };

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

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
}

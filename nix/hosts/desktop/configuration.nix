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

  networking.hostName = "desktop"; # Define your hostname.
  systemd.network.enable = false;

  boot.kernelParams = [
    "amd_pstate=disable" # not supported by 3700x
    "preempt=full" # kernel becomes preemptible at almost every point in its execution, better for audio/gaming
    "zswap.enabled=1" # enables zswap
    "zswap.compressor=zstd" # compression algorithm
    "zswap.max_pool_percent=20" # maximum percentage of RAM that zswap is allowed to use
    "zswap.shrinker_enabled=1" # whether to shrink the pool proactively on high memory pressure
  ];

  services.pipewire.extraConfig.pipewire."98-crackling-fix" = {
    "context.properties" = {
      "default.clock.quantum" = 512;
      "default.clock.min-quantum" = 512;
      "default.clock.max-quantum" = 8192;
    };
  };

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
  systemd.services.libvirt-network-default = {
    wantedBy = [ "multi-user.target" ];
    after = [ "libvirtd.service" ];
    requires = [ "libvirtd.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.libvirt}/bin/virsh net-start default || true'";
    };
  };

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
    lm_sensors
    mesa
    mullvad-vpn
    mullvad-browser
    kdePackages.dolphin
    wezterm
    vlc
    wget
  ];

  # Fix for Dolphin lacking file associations
  environment.etc."xdg/menus/applications.menu".source =
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  services.displayManager.gdm.enable = true;
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  services.syncthing = {
    enable = true;
    user = "jemag";
    dataDir = "/home/jemag";
    configDir = "/home/jemag/.config/syncthing";
    openDefaultPorts = true;
    settings = {
      devices = {
        "pixel7" = {
          id = "RPTKM3C-B57PYYP-4PLM32G-XQPHDH4-JPMVDQ5-GPJWZLA-3QKKWVT-B2J7QAE";
        };
      };
      folders = {
        "obsidian" = {
          id = "obsidian";
          path = "/home/jemag/H/obsidian";
          devices = [ "pixel7" ];
        };
        # "camera" = {
        #   id = "pixel_7_n5v1-photos";
        #   type = "receiveonly";
        #   path = "/home/jemag/syncthing/camera";
        #   devices = [ "pixel7" ];
        # };
        # "pictures" = {
        #   id = "o2cnd-52gae";
        #   type = "receiveonly";
        #   path = "/home/jemag/syncthing/pictures";
        #   devices = [ "pixel7" ];
        # };
      };
      gui = {
        user = "jemag";
      };
    };
  };

  # NOTE: password for the user must be configured using smbpasswd -a jemag
  services.samba = {
    enable = true;
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

  services.xserver.videoDrivers = [ "amdgpu" ];

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

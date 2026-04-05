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

  networking.hostName = "homelab"; # Define your hostname.
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

  users.users.jemag = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBYd83e4sGijxVajgzH4CpvvJ6YBUwHQViUI3zRyqvQD"
    ];
    extraGroups = [
      "wheel"
      "docker"
    ];
  };

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    dnsmasq
    killall
    gnumake
    gcc
    autoconf
    automake
    libtool
    wget
  ];

  services.openssh = {
    enable = true;
    ports = [ 5432 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "jemag" ];
    };
  };

  # services.syncthing = {
  #   enable = true;
  #   user = "jemag";
  #   dataDir = "/home/jemag";
  #   configDir = "/home/jemag/.config/syncthing";
  #   openDefaultPorts = true;
  #   settings = {
  #     devices = {
  #       "pixel7" = {
  #         id = "RPTKM3C-B57PYYP-4PLM32G-XQPHDH4-JPMVDQ5-GPJWZLA-3QKKWVT-B2J7QAE";
  #       };
  #     };
  #     folders = {
  #       "obsidian" = {
  #         id = "obsidian";
  #         path = "/home/jemag/H/obsidian";
  #         devices = [ "pixel7" ];
  #       };
  #       # "camera" = {
  #       #   id = "pixel_7_n5v1-photos";
  #       #   type = "receiveonly";
  #       #   path = "/home/jemag/syncthing/camera";
  #       #   devices = [ "pixel7" ];
  #       # };
  #       # "pictures" = {
  #       #   id = "o2cnd-52gae";
  #       #   type = "receiveonly";
  #       #   path = "/home/jemag/syncthing/pictures";
  #       #   devices = [ "pixel7" ];
  #       # };
  #     };
  #     gui = {
  #       user = "jemag";
  #     };
  #   };
  # };

  # NOTE: password for the user must be configured using smbpasswd -a jemag
  # services.samba = {
  #   enable = true;
  #   openFirewall = true;
  #   settings = {
  #     global = {
  #       workgroup = "WORKGROUP";
  #       "invalid users" = [ "root" ];
  #       "passwd program" = "/run/wrappers/bin/passwd %u";
  #       security = "user";
  #       "guest ok" = "no";
  #     };
  #     jemag = {
  #       browseable = "yes";
  #       comment = "Home directories";
  #       path = "/home/jemag";
  #       "read only" = "yes";
  #       "valid users" = "jemag";
  #     };
  #   };
  # };
  # services.samba-wsdd = {
  #   enable = true;
  #   openFirewall = true;
  # };

  # services.xserver.videoDrivers = [ "nvidia" ];

  networking.firewall.enable = true;
}

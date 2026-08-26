{
  config,
  lib,
  pkgs,
  nixos-wsl,
  ...
}:

{
  imports = [
    nixos-wsl.nixosModules.default
    ../../modules/nixos/common.nix
  ];

  # Distinct from the Arch instance's WSQCIML9115246 so the two can coexist and
  # `nh {os,home} switch .` resolves the right config on each.
  networking.hostName = "work";

  # Other hosts get this from hardware-configuration.nix; there is none here.
  nixpkgs.hostPlatform = "x86_64-linux";

  wsl = {
    enable = true;
    defaultUser = "jemag";
    startMenuLaunchers = true;

    # Keep /mnt/c/... on PATH. clip.exe (tmux-wsl/.tmux.conf), wslview
    # (zsh-wsl/.zshenv BROWSER) and neovim's powershell.exe paste provider
    # (neovim/.config/nvim/lua/winclip.lua) all depend on this.
    interop.includePath = true;

    # Mirrors the hand-written /etc/wsl.conf from the Arch instance.
    wslConf = {
      boot.systemd = true;
      automount = {
        enabled = true;
        options = "metadata";
        mountFsTab = true;
      };
    };
  };

  # Replaces Arch's docker.service. Socket stays at /var/run/docker.sock, so the
  # existing `docker context ls` default keeps working.
  virtualisation.docker.enable = true;
  users.users.jemag.extraGroups = [ "docker" ];

  # mise, npm/pip native modules, rustup toolchains and the VSCode/Cursor
  # remote-WSL server are prebuilt against FHS paths and will not find ld-linux
  # without this. Biggest behavioural difference from Arch.
  programs.nix-ld.enable = true;

  # Arch prompted for the sudo password; nixos-wsl defaults to passwordless.
  security.sudo.wheelNeedsPassword = true;

  # nixos-wsl sets `hardware.graphics.enable = true` unconditionally (a plain
  # `true`, not mkDefault - hence mkForce). That builds /run/opengl-driver from
  # mesa, but the Windows GPU libraries it exists to expose are gated separately:
  #   extraPackages = mkIf cfg.useWindowsDriver [ cfg.wslLib ];
  # With useWindowsDriver = false that is closure with no benefit, and there are
  # no GUI apps here. Measured on this config: 3.3 GiB -> 2.5 GiB of system
  # closure (mesa, llvm-lib, vulkan-loader, libdrm, wayland).
  # To reverse: drop this and set `wsl.useWindowsDriver = true` (needed for
  # CUDA / DirectML / any WSLg app).
  hardware.graphics.enable = lib.mkForce false;

  environment.systemPackages = with pkgs; [
    wsl-open # BROWSER in zsh-wsl/.zshenv, `wo` alias; replaces the removed wslu
    cifs-utils # was an explicit pacman package; for `sudo mount -t cifs`
    dotnet-sdk # Arch had dotnet-sdk; cli.nix only carries dotnet-aspnetcore
    xdg-utils # `xo` alias -> xdg-open, delegated to Windows via wslview
  ];
}

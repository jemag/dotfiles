{
  config,
  lib,
  pkgs,
  ...
}:

{
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

  # overlays.nix is otherwise only applied to the flake-level `pkgs` used by
  # homeConfigurations; NixOS builds never saw it.
  nixpkgs.overlays = import ../../overlays.nix;

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";

  users.users.jemag = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [ tree ];
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    bash
    git
    bitwarden-cli
    jq
  ];

  system.stateVersion = "25.05";
}

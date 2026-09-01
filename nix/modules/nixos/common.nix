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

  # Generation-count retention, which nix.gc cannot express: it feeds
  # nix-collect-garbage, which only offers age-based --delete-older-than.
  #
  # This is the nixpkgs NixOS module, not the home-manager module of the same
  # name: it creates the root-run nh-clean.service, so unlike cli.nix's
  # `nh clean user` it also prunes /nix/var/nix/profiles/system.
  #
  # programs.nh.enable is deliberately left off - clean.enable is gated
  # independently of it, so no second nh lands on PATH and no NH_FLAKE is set,
  # leaving home-manager's NH_HOME_FLAKE authoritative.
  #
  # No --optimise: auto-optimise-store above already hard-links identical paths
  # as they enter the store, so a full nix-store --optimise pass would be heavy
  # I/O for nothing.
  programs.nh.clean = {
    enable = true;
    dates = "daily";
    extraArgs = "--keep 5 --keep-since 7d";
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

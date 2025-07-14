{
  description = "Home manager configuration";
  nixConfig = {
    extra-substituters =
      [ "https://cache.nixos.org" "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      nixosConfigurations = {
        live = lib.nixosSystem {
          inherit system;
          modules = [
            (nixpkgs
              + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
            ./configuration.nix
          ];
        };
      };
      nixosConfigurations = {
        thinkpad = lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/thinkpad/configuration.nix ];
        };
      };
      homeConfigurations = {
        "jemag@jemag-laptop" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./hosts/laptop.nix ];
        };
        "jemag@WSQCIML9079824" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./hosts/work.nix ];
        };
        "jemag@archhome" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./hosts/desktop.nix ];
        };
        "jemag@thinkpad" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./hosts/thinkpad/home.nix ];
        };
      };
    };
}

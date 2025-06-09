{
  description = "Home manager configuration";

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
        nixos = lib.nixosSystem {
          inherit system;
          modules = [ ./configuration.nix ];
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
        "jemag@nixos" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./hosts/nixos-desktop.nix ];
        };
      };
    };
}

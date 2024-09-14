{
  description = "Home manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpgks.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
    lib = nixpkgs.lib;
  system = "x86_64-linux";
  pkgs = import nixpkgs { inherit system; };
  in {
    homeConfigurations = {
      myprofile = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
      };
    };
  };
}

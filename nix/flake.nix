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
      javaLspScript = pkgs.writeShellScriptBin "javaLspScript" ''
        set -ev
        JDTLS_CONFIG_DIR=~/jdtls-config
        mkdir -p $JDTLS_CONFIG_DIR
        cp -r ${pkgs.jdt-language-server}/share/java/jdtls/config_linux/* $JDTLS_CONFIG_DIR/
        chmod -R 755 $JDTLS_CONFIG_DIR

        java \
        -Declipse.application=org.eclipse.jdt.ls.core.id1 \
        -Dosgi.bundles.defaultStartLevel=4 \
        -Declipse.product=org.eclipse.jdt.ls.core.product \
        -Dlog.protocol=true \
        -Dlog.level=ALL \
        -javaagent:"${pkgs.lombok}/share/java/lombok.jar" \
        -Xms1g \
        --add-modules=ALL-SYSTEM \
        --add-opens \
        java.base/java.util=ALL-UNNAMED \
        --add-opens \
        java.base/java.lang=ALL-UNNAMED \
        -jar ${pkgs.jdt-language-server}/share/java/jdtls/plugins/org.eclipse.equinox.launcher_*.jar \
        -configuration $JDTLS_CONFIG_DIR \
        -data \
        ~/workspace/
      '';
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
          modules = [
            ./hosts/nixos-desktop.nix
            ({ config, ... }: { home.packages = [ javaLspScript ]; })
          ];
        };
      };
    };
}

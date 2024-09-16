{ lib, config, pkgs, ... }:
let cfg = config.gui;
in
{
  options = {
    gui.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable gui programs";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    #config contents
    home.packages = with pkgs; [
      chromium
      firefox
      bitwarden
      ticktick
    ];
  };
}

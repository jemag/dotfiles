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

    xdg = {
      mimeApps = {
        enable = true;
        associations = {
          added = {

            "application/json" = [ "nvim-qt.desktop" ];
            "application/octet-stream" = [ "firefox.desktop" "firefox-developer-edition.desktop" "org.qbittorrent.qBittorrent.desktop" ];
            "application/octetstream" = [ "nvim-qt.desktop" ];
            "application/pdf" = [ "firefox.desktop" "org.pwmt.zathura-pdf-mupdf.desktop" "com.github.xournalpp.xournalpp.desktop" "libreoffice-draw.desktop" "wine-extension-pdf.desktop" ];
            "application/vnd.ms-visio.drawing" = [ "libreoffice-draw.desktop" ];
            "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [ "onlyoffice-desktopeditors.desktop" "libreoffice-writer.desktop" ];
            "application/x-bittorrent" = [ "org.qbittorrent.qBittorrent.desktop" "deluge.desktop"];
            "application/x-xopp" = ["com.github.xournalpp.xournalpp.desktop"];
            "image/jpeg" = [ "sxiv.desktop" ];
            "image/png" = ["sxiv.desktop"];
            "text/calendar" = ["firefox-developer-edition.desktop"];
            "text/plain" = [ "nvim-qt.desktop" "wine-extension-txt.desktop" ];
            "text/x-java-source" = [ "nvim-qt.desktop" ];
            "text/x-log" = ["nvim-qt.desktop"];
            "text/yaml" = ["nvim-qt.desktop" "gvim.desktop"];
            "text/csv" = ["libreoffice-calc.desktop"];
            "x-scheme-handler/http" = ["firefox.desktop"];
            "x-scheme-handler/https" = ["firefox.desktop"];
            "x-scheme-handler/chrome" = ["firefox.desktop"];
            "text/html" = ["firefox.desktop"];
            "application/x-extension-htm" = ["firefox.desktop"];
            "application/x-extension-html" = ["firefox.desktop"];
            "application/x-extension-shtml" = ["firefox.desktop"];
            "application/xhtml+xml" = ["firefox.desktop"];
            "application/x-extension-xhtml" = ["firefox.desktop"];
            "application/x-extension-xht" = ["firefox.desktop"];
            "application/msword" = ["onlyoffice-desktopeditors.desktop"];

          };
        };
        defaultApplications = {
          "application/json" = [ "nvim-qt.desktop" ];
          "application/pdf" = [ "org.pwmt.zathura.desktop" ];
          "application/x-yaml" = [ "nvim-qt.desktop" ];
          "image/jpeg" = [ "sxiv.desktop" ];
          "image/png" = [ "sxiv.desktop" ];
          "text/markdown" = [ "nvim-qt.desktop" ];
          "text/plain" = [ "nvim-qt.desktop" ];
          "x-schema-handler/msteams" = [ "teams.desktop" ];
          "x-scheme-handler/jetbrains" = [ "jetbrains-toolbox.desktop" ];
          "x-scheme-handler/msteams" = [ "teams.desktop" ];
          "x-scheme-handler/http" = [ "firefox.desktop" ];
          "x-scheme-handler/https" = [ "firefox.desktop" ];
          "x-scheme-handler/chrome" = [ "firefox.desktop" ];
          "text/html" = [ "firefox.desktop" ];
          "application/x-extension-htm" = [ "firefox.desktop" ];
          "application/x-extension-html" = [ "firefox.desktop" ];
          "application/x-extension-shtml" = [ "firefox.desktop" ];
          "application/xhtml+xml" = [ "firefox.desktop" ];
          "application/x-extension-xhtml" = [ "firefox.desktop" ];
          "application/x-extension-xht" = [ "firefox.desktop" ];
          "inode/directory" = [ "pcmanfm.desktop" ];
        };
      };
    };
    home.packages = with pkgs; [
      arandr
      bitwarden
      chromium
      deluge
      feh
      flameshot
      firefox
      nerd-fonts.fira-code
      ksnip
      libreoffice-fresh
      onlyoffice-desktopeditors
      python313Packages.pylatexenc
      neovim-qt
      obsidian
      pandoc
      qalculate-gtk
      signal-desktop
      spotify
      sxiv
      ticktick
      redshift
      ueberzugpp
      zathura
    ];
  };
}

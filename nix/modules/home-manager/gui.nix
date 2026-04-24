{ lib, config, pkgs, ... }:
let cfg = config.gui;
in {
  options = {
    gui.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable gui programs";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    #config contents
    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = { color-scheme = "prefer-dark"; };
      };
    };
    gtk = {
      enable = true;
      gtk4.theme = config.gtk.theme;
      theme = {

        package = pkgs.ayu-theme-gtk;
        name = "Ayu-Dark";
      };
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus";
      };
      cursorTheme = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Original-Classic";
        size = 22;
      };
    };

    qt = {
      enable = true;
      platformTheme = { name = "gtk3"; };
    };

    services.blueman-applet.enable = true;
    xdg = {
      mimeApps = {
        enable = true;
        associations = {
          added = {

            "application/json" = [ "nvim-qt.desktop" ];
            "application/octet-stream" = [
              "firefox.desktop"
              "firefox-developer-edition.desktop"
              "org.qbittorrent.qBittorrent.desktop"
            ];
            "application/octetstream" = [ "nvim-qt.desktop" ];
            "application/pdf" = [
              "firefox.desktop"
              "org.pwmt.zathura-pdf-mupdf.desktop"
              "com.github.xournalpp.xournalpp.desktop"
              "libreoffice-draw.desktop"
              "wine-extension-pdf.desktop"
            ];
            "application/vnd.ms-visio.drawing" = [ "libreoffice-draw.desktop" ];
            "application/vnd.openxmlformats-officedocument.wordprocessingml.document" =
              [
                "onlyoffice-desktopeditors.desktop"
                "libreoffice-writer.desktop"
              ];
            "application/x-bittorrent" =
              [ "org.qbittorrent.qBittorrent.desktop" "deluge.desktop" ];
            "application/x-xopp" = [ "com.github.xournalpp.xournalpp.desktop" ];
            "image/jpeg" = [ "sxiv.desktop" ];
            "image/png" = [ "sxiv.desktop" ];
            "text/calendar" = [ "firefox-developer-edition.desktop" ];
            "text/plain" = [ "nvim-qt.desktop" "wine-extension-txt.desktop" ];
            "text/x-java-source" = [ "nvim-qt.desktop" ];
            "text/x-log" = [ "nvim-qt.desktop" ];
            "text/yaml" = [ "nvim-qt.desktop" "gvim.desktop" ];
            "text/csv" = [ "libreoffice-calc.desktop" ];
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
            "application/msword" = [ "onlyoffice-desktopeditors.desktop" ];

          };
        };
        defaultApplications = {
          "application/json" = [ "nvim-qt.desktop" ];
          "application/pdf" = [ "sioyek.desktop" ];
          "application/x-yaml" = [ "nvim-qt.desktop" ];
          "image/jpeg" = [ "org.kde.gwenview.desktop" ];
          "image/png" = [ "org.kde.gwenview.desktop" ];
          "text/markdown" = [ "nvim-qt.desktop" ];
          "text/plain" = [ "nvim-qt.desktop" ];
          "x-schema-handler/msteams" = [ "teams.desktop" ];
          "x-scheme-handler/jetbrains" = [ "jetbrains-toolbox.desktop" ];
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
    home.file = {
      ".config/mako" = {
        source = config.lib.file.mkOutOfStoreSymlink
          "${config.home.homeDirectory}/dotfiles/mako/.config/mako";
      };
      ".config/rofi" = {
        source = config.lib.file.mkOutOfStoreSymlink
          "${config.home.homeDirectory}/dotfiles/rofi/.config/rofi";
      };
      ".local/share/rofi" = {
        source = config.lib.file.mkOutOfStoreSymlink
          "${config.home.homeDirectory}/dotfiles/rofi/.local/share/rofi";
      };
      "wallpapers" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/wallpapers/wallpapers";
      };
    };
    home.sessionVariables = {
      XDG_CURRENT_DESKTOP = "sway";
      GTK_THEME = "Ayu-Dark";
      XDG_THEME_PREFERENCE = "dark";
    };
    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Original-Classic";
      size = 22;
    };
    home.packages = with pkgs; [
      arandr
      bitwarden-desktop
      chromium
      deluge
      feh
      flameshot
      firefox
      gtk3
      nerd-fonts.fira-code
      ksnip
      libreoffice-fresh
      onlyoffice-desktopeditors
      python313Packages.pylatexenc
      kdePackages.gwenview
      mission-center
      neovim-qt
      obsidian
      playerctl
      pavucontrol
      pulseaudio
      qalculate-gtk
      signal-desktop
      spotify
      sxiv
      ticktick
      redshift
      sioyek
      gammastep
      showmethekey
      ueberzugpp
      zathura
      element-desktop
      epub-thumbnailer
      pcmanfm
      vulkan-tools
      nwg-displays
      obs-studio
      xdg-desktop-portal
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };
}

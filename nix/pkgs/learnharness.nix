{ pkgs }:

let
  pname = "learn-harness";
  version = "1.0.0";
  src = pkgs.fetchurl {
    url = "https://github.com/amosblomqvist/learnharness/releases/download/v0.3.7/LearnHarness-0.3.7-x86_64.AppImage";
    hash = "sha256-7zRlGDOxGOpcdEnM2UUFgBB66xg+bHGrFQdrQ7xFGOw=";
  };

  appimageContents = pkgs.appimageTools.extract { inherit pname version src; };
in
pkgs.appimageTools.wrapType2 {
  inherit pname version src;
  extraPkgs = pkgs: with pkgs; [ fuse ];

  extraInstallCommands = ''
    # Install .desktop file
    install -m 444 -D ${appimageContents}/learnharness.desktop $out/share/applications/learnharness.desktop

    # Install icon (512x512 is standard)
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/learnharness.png \
      $out/share/icons/hicolor/512x512/apps/learnharness.png

    # Fix Exec line: AppRun -> wrapped binary name
    substituteInPlace $out/share/applications/learnharness.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=learn-harness'
  '';
}
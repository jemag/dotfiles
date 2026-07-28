{ pkgs }:

pkgs.buildGoModule rec {
  pname = "tcping";
  version = "2.8.0";

  src = pkgs.fetchFromGitHub {
    owner = "pouriyajamshidi";
    repo = "tcping";
    rev = "v${version}";
    hash = "sha256-J2vmpRyPLXyW6NZ1T+eL+ZKcjtPJluKMghW/99ehAAA=";
  };

  vendorHash = "sha256-/0Lhmq65QVNsy5Xyv+fIcXRgY/i0MGfDCvptzm2Y0qA=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = {
    description = "Ping TCP ports, inspired by Linux's ping utility";
    homepage = "https://github.com/pouriyajamshidi/tcping";
    license = pkgs.lib.licenses.mit;
    mainProgram = "tcping";
  };
}

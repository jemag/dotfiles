{ pkgs }:

pkgs.stdenvNoCC.mkDerivation rec {
  pname = "opencode-model-router";
  version = "1.1.15";

  src = pkgs.fetchFromGitHub {
    owner = "marco-jardim";
    repo = "opencode-model-router";
    rev = "ce3253883834b921eac89e163a8fbb128993b561";
    hash = "sha256-/zRUyqAiS7HaFfoLlI3JQqJF4Eo3lMwlHr7SyJjGYmE=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    cp -r src package.json $out/
  '';
}

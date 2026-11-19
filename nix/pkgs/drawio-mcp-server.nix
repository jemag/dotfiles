{ pkgs }:

let
  pnpm = pkgs.pnpm_10;
  nodejs = pkgs.nodejs_22;
in
pkgs.stdenv.mkDerivation (finalAttrs: {
  pname = "drawio-mcp-server";
  version = "2.4.0";

  src = pkgs.fetchFromGitHub {
    owner = "lgazo";
    repo = "drawio-mcp-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FuYHe+6SFi0ig9IfmuxrbybQ1M43IvDlQJUmCBK3bI4=";
  };

  pnpmDeps = pkgs.fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 5;
    hash = "sha256-6HXhAOtR9+asx6smIdyRNReYG4b7a81eTJ91IurkFFY=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm
    pkgs.pnpmConfigHook
    pkgs.makeBinaryWrapper
  ];

  buildPhase = ''
    runHook preBuild
    pnpm --filter "drawio-mcp-server..." build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    pnpm --filter drawio-mcp-server deploy --prod --offline --config.inject-workspace-packages=true "$out/lib/drawio-mcp-server"
    makeWrapper ${pkgs.lib.getExe nodejs} $out/bin/drawio-mcp-server \
      --add-flags "$out/lib/drawio-mcp-server/build/index.js"
    runHook postInstall
  '';

  meta = {
    description = "MCP server that lets AI agents control Draw.io diagrams";
    homepage = "https://github.com/lgazo/drawio-mcp-server";
    license = pkgs.lib.licenses.mit;
    mainProgram = "drawio-mcp-server";
  };
})

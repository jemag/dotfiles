{ pkgs }:

pkgs.buildGoModule {
  pname = "mcp-whisker-go";
  version = "0-unstable-2025-11-26";

  src = pkgs.fetchFromGitHub {
    owner = "aadhilam";
    repo = "mcp-whisker-go";
    rev = "6cba985519335f7bed799ff7665b66cdff657698";
    hash = "sha256-fWfg3r52L23EjYn8Y0pbRvVjKEILoH1im/5O2I5p964=";
  };

  vendorHash = "sha256-L+sCBVUXHMB4pT+z9u7sFDDSMRCxRWGjgDPe+dRRq7c=";

  subPackages = [ "cmd/server" ];

  nativeBuildInputs = [ pkgs.makeBinaryWrapper ];

  ldflags = [
    "-s"
    "-w"
  ];

  # cmd/server builds as "server"; repo configs call it mcp-whisker-go.
  # --suffix so the user's kubectl (and kubelogin for AKS auth) wins when present.
  postInstall = ''
    mv $out/bin/server $out/bin/mcp-whisker-go
    wrapProgram $out/bin/mcp-whisker-go \
      --suffix PATH : ${
        pkgs.lib.makeBinPath [
          pkgs.kubectl
          pkgs.lsof
        ]
      }
  '';

  meta = {
    description = "MCP server for Calico Whisker flow log analysis";
    homepage = "https://github.com/aadhilam/mcp-whisker-go";
    # No LICENSE file upstream; README declares MIT.
    license = pkgs.lib.licenses.mit;
    mainProgram = "mcp-whisker-go";
  };
}

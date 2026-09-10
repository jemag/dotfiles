{ pkgs }:

(pkgs.buildGoModule.override { go = pkgs.go_1_27; }) rec {
  pname = "network-doctor";
  version = "1.16.4";

  src = pkgs.fetchFromGitHub {
    owner = "heymaikol";
    repo = "network-doctor";
    rev = "v${version}";
    hash = "sha256-jjDbp/8/QNerZ9G2uLlcUs9TjkWTaGeMsO00iTzRg78=";
  };

  vendorHash = "sha256-5BYcBmNY/jOpNjuL9KhsSBgk5FUQfI9IOwrhEArqh88=";

  # The root main package is the release build target; cmd/netdoc is the same CLI
  # but carries no tests, so building "." keeps the check phase meaningful. Go
  # names the root binary after the module, hence the rename below. netdoc-sim
  # is the Challenge Mode simulator; it finds netdoc alongside itself in bin/.
  subPackages = [
    "."
    "cmd/netdoc-sim"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  nativeBuildInputs = [ pkgs.installShellFiles ];

  # The bash-completion test drives `compgen`, which nixpkgs' non-interactive
  # bash does not provide; without this every subtest returns no candidates.
  nativeCheckInputs = [ pkgs.bashInteractive ];

  postInstall = ''
    mv $out/bin/network-doctor $out/bin/netdoc
    installManPage packaging/netdoc.1 packaging/netdoc-sim.1
    installShellCompletion --cmd netdoc \
      --bash packaging/completions/netdoc.bash \
      --zsh packaging/completions/netdoc.zsh \
      --fish packaging/completions/netdoc.fish
    installShellCompletion --cmd netdoc-sim \
      --bash packaging/completions/netdoc-sim.bash \
      --zsh packaging/completions/netdoc-sim.zsh \
      --fish packaging/completions/netdoc-sim.fish
  '';

  meta = {
    description = "Cross-platform network troubleshooting TUI that turns interface, DNS, TCP, TLS, HTTP, proxy, and path-MTU checks into one plain-English diagnosis";
    homepage = "https://github.com/heymaikol/network-doctor";
    license = pkgs.lib.licenses.asl20;
    mainProgram = "netdoc";
  };
}

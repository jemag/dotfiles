{ pkgs }:

# Tracks upstream main: v0.7.0 (the latest tag, also what nixpkgs ships) predates
# configurable prefix bindings, directional pane focus and the session switcher.
# Upstream's own flake has a stale vendorHash, so it can't be used as an input.
pkgs.buildGoModule (finalAttrs: {
  pname = "tuios";
  version = "0.7.0-unstable-2026-09-27";

  src = pkgs.fetchFromGitHub {
    owner = "Gaurav-Gosain";
    repo = "tuios";
    rev = "246792e5e5152db94bcd23f5a64cdbc103b3caa5";
    hash = "sha256-Fx3OD5TqBDtu8vYoNak08NPlHhoSA3caaE0byZ2iJso=";
  };

  vendorHash = "sha256-FxFBLAKt818Olyr1sUoT2wbLq715znnVd4mqhk8IgUk=";

  subPackages = [ "cmd/tuios" ];

  # cmd/tuios integration tests spawn ssh, a daemon and edit ~/.claude; they
  # fail inside the sandbox.
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.rev}"
    "-X=main.date=1970-01-01T00:00:00Z"
    "-X=main.builtBy=nixpkgs"
  ];

  nativeBuildInputs = [ pkgs.installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd tuios \
      --bash <($out/bin/tuios completion bash) \
      --fish <($out/bin/tuios completion fish) \
      --zsh <($out/bin/tuios completion zsh)
  '';

  meta = {
    description = "Terminal-based window manager";
    homepage = "https://github.com/Gaurav-Gosain/tuios";
    license = pkgs.lib.licenses.mit;
    mainProgram = "tuios";
  };
})

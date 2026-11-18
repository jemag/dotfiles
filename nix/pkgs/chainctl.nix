{ pkgs }:

pkgs.stdenvNoCC.mkDerivation rec {
  pname = "chainctl";
  version = "0.2.406";

  src = pkgs.fetchurl {
    url = "https://dl.enforce.dev/chainctl/${version}/chainctl_linux_x86_64";
    hash = "sha256-rWXKJ83QwZXOPqJ+BqOYh2ZDw2k6z48X+jO88lqLYUc=";
  };

  dontUnpack = true;
  nativeBuildInputs = [ pkgs.installShellFiles ];

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/chainctl
    runHook postInstall
  '';

  # cobra-generated completions; HOME redirected so it doesn't try to touch ~/.config
  postInstall = ''
    export HOME=$TMPDIR
    installShellCompletion --cmd chainctl \
      --bash <($out/bin/chainctl completion bash) \
      --zsh  <($out/bin/chainctl completion zsh) \
      --fish <($out/bin/chainctl completion fish)
  '';

  meta = {
    description = "Chainguard CLI for managing Chainguard Images/registry access";
    homepage = "https://edu.chainguard.dev/chainguard/chainctl/";
    license = pkgs.lib.licenses.unfree;
    sourceProvenance = [ pkgs.lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "chainctl";
  };
}

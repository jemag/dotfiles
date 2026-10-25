{ pkgs }:

pkgs.rustPlatform.buildRustPackage {
  pname = "leaf-markdown-viewer";
  version = "1.29.1";

  src = pkgs.fetchFromGitHub {
    owner = "RivoLink";
    repo = "leaf";
    rev = "1.29.1"; # tag has no "v" prefix
    hash = "sha256-+J8c6aoM2GqZMJe2XUiY4A6T1qqw1s1+kVMhdHKSt8o=";
  };

  cargoHash = "sha256-pbzCRd6BoImGL2DXInGRiiobk1CnMEmmeH1tetzNLnQ=";

  nativeBuildInputs = [ pkgs.installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd leaf \
      --bash completions/leaf.bash \
      --zsh completions/leaf.zsh \
      --fish completions/leaf.fish
  '';

  meta = {
    description = "Terminal Markdown previewer with a GUI-like experience";
    homepage = "https://github.com/RivoLink/leaf";
    license = pkgs.lib.licenses.mit;
    mainProgram = "leaf";
  };
}

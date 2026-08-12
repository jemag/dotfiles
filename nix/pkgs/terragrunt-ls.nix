{ pkgs }:

pkgs.buildGoModule rec {
  pname = "terragrunt-ls";
  version = "0.0.6";

  src = pkgs.fetchFromGitHub {
    owner = "gruntwork-io";
    repo = "terragrunt-ls";
    rev = "v${version}";
    hash = "sha256-nd4lo5tjNKINr+nCeewz/zlcsvqAnmWBcmC0Z+aDlHY=";
  };

  vendorHash = "sha256-wqQPMVP2822N55m5A0/EiCzgVPITJkfrKlHwQWvSte0=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Language server for Terragrunt configuration files";
    homepage = "https://github.com/gruntwork-io/terragrunt-ls";
    license = pkgs.lib.licenses.mpl20;
    mainProgram = "terragrunt-ls";
  };
}

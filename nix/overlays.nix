# NOTE: temporary fix for https://github.com/NixOS/nixpkgs/issues/513245
[
  (_: prev: {
    openldap = prev.openldap.overrideAttrs {
      doCheck = !prev.stdenv.hostPlatform.isi686;
    };
  })
]

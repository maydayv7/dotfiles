_: prev: let
  # ! # Remove pin once added back
  src = prev.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "347962c169325f96514fe6c9e21dd8571e74b99d";
    hash = "sha256-bre+jKk60t+eNNwseiVOzJ15cAk6rA6EO4Hwwx7AMto=";
  };
in {
  # Brave Browser Flags
  brave = (prev.callPackage "${src}/pkgs/by-name/br/brave/package.nix" {}).overrideAttrs (old: {
    postFixup =
      (old.postFixup or "")
      + ''
        flags="--enable-features="
        fix="--gtk-version=4 --enable-features=TouchpadOverscrollHistoryNavigation,"
        substituteInPlace $out/bin/brave \
          --replace-fail "$flags" "$fix"
      '';
  });
}

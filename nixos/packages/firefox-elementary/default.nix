{
  lib,
  pkgs,
  ...
}:
with pkgs; let
  metadata = import ./metadata.nix;
in
  stdenv.mkDerivation rec {
    pname = "elementaryos-firefox-theme";
    version = metadata.rev;

    src = fetchFromGitHub {
      owner = "Zonnev";
      repo = pname;
      inherit (metadata) rev sha256;
    };

    dontBuild = true;
    installPhase = "mkdir -p $out/ && cp -r . $out/";

    meta = with lib; {
      description = "An Elementary OS Theme for Firefox";
      homepage = metadata.repo;
      license = licenses.mpl20;
      maintainers = ["maydayv7"];
    };
  }

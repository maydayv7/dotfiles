{
  lib,
  pkgs,
  ...
}:
with pkgs; let
  metadata = import ./metadata.nix;
in
  stdenv.mkDerivation {
    pname = "superpowers";
    version = metadata.rev;

    src = fetchFromGitHub {
      owner = "obra";
      repo = "superpowers";
      inherit (metadata) rev sha256;
    };

    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/superpowers
      cp -r ./. $out/share/superpowers/
    '';

    meta = {
      description = "Composable agentic skills library for coding agents";
      homepage = metadata.repo;
      license = lib.licenses.mit;
      maintainers = ["maydayv7"];
    };
  }

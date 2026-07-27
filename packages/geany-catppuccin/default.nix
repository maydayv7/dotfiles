{
  lib,
  pkgs,
  ...
}:
with pkgs; let
  metadata = import ./metadata.nix;
in
  stdenv.mkDerivation {
    pname = "geany-catppuccin";
    version = metadata.rev;

    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "geany";
      inherit (metadata) rev sha256;
    };

    dontBuild = true;
    patches = [./selection.patch];
    installPhase = ''
      mkdir -p $out/share/geany/colorschemes/
      cp -r ./src/. $out/share/geany/colorschemes/
    '';

    meta = {
      description = "Soothing pastel theme for Geany";
      homepage = metadata.repo;
      license = lib.licenses.mit;
      maintainers = ["maydayv7"];
    };
  }

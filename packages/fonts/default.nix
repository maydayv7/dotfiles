{ inputs, pkgs, ... }:
with pkgs;
stdenv.mkDerivation rec
{
  pname = "fonts";
  version = "7";

  src = inputs.fonts;

  dontBuild = true;

  installPhase =
  ''
    mkdir -p $out/share/fonts/
    cp -r * $out/share/fonts/
  '';
}
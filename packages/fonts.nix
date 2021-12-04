{ pkgs, files ? import ../files }:
with pkgs;
stdenv.mkDerivation rec
{
  pname = "fonts";
  version = "7";

  src = files.fonts.path;

  dontBuild = true;

  installPhase =
  ''
    mkdir -p $out/share/fonts/
    cp -r * $out/share/fonts/
  '';
}

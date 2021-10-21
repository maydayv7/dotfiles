{ inputs, pkgs, ... }:
with pkgs;
stdenv.mkDerivation rec
{
  pname = "gnome-firefox";
  version = "90";
  
  src = inputs.gnome-firefox;
  
  dontBuild = true;
  
  installPhase =
  ''
    mkdir -p $out/firefox-gnome-theme
    cp -r * $out/firefox-gnome-theme
  '';
}

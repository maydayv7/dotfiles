{ pkgs, ... }:
with pkgs;
stdenv.mkDerivation rec
{
  pname = "product-sans";
  version = "7";
  
  src = ./sources/product-sans;
  
  dontBuild = true;
  
  installPhase =
  ''
    mkdir -p $out/share/fonts/custom/
    cp * $out/share/fonts/custom/
  '';
}

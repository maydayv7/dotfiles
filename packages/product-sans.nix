{ lib, stdenv }:
stdenv.mkDerivation rec
{
  pname = "product-sans";
  version = "7";
  
  src = ./sources/product-sans;
  
  dontBuild = true;
  
  installPhase =
  ''
    mkdir -p $out/share/fonts/product-sans/
    cp ./* $out/share/fonts/product-sans/
  '';
}

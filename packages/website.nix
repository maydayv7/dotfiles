{
  site ? null,
  pkgs ? import <nixpkgs> {},
  ...
}:
with pkgs;
  stdenvNoCC.mkDerivation rec {
    pname = "website";
    version = "stable";
    src = ../site;
    buildInputs = [zola];
    installPhase = "cp -r public $out";
    buildPhase = "zola build ${
      if (site != null)
      then "--base-url " + site
      else ""
    }";
  }

{
  site ? null,
  pkgs ? import ../.,
  files ? {website = ../site;},
  ...
}:
with pkgs;
  stdenvNoCC.mkDerivation rec {
    pname = "website";
    version = "stable";
    src = files.website;
    buildInputs = [zola];
    installPhase = "cp -r public $out";
    buildPhase = "zola build ${
      if (site != null)
      then "--base-url " + site
      else ""
    }";
  }

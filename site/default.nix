{
  site ? null,
  pkgs,
}:
with pkgs;
  stdenvNoCC.mkDerivation rec {
    pname = "website";
    version = "stable";
    src = ./.;
    buildInputs = [zola];
    installPhase = "cp -r public $out";
    buildPhase = "zola build ${
      if (site != null)
      then "--base-url " + site
      else ""
    }";
  }

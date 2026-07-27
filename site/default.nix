{
  site ? null,
  lib,
  pkgs,
}:
pkgs.stdenvNoCC.mkDerivation {
  pname = "website";
  version = "stable";
  src = ./.;

  buildInputs = [pkgs.zola];
  installPhase = "cp -r public $out";
  buildPhase = "zola build ${
    if (site != null)
    then "--base-url " + site
    else ""
  }";

  meta = {
    description = "My Personal Website";
    license = lib.licenses.gpl3Only;
    maintainers = ["maydayv7"];
  };
}

{
  site ? null,
  lib,
  pkgs,
}:
pkgs.stdenvNoCC.mkDerivation {
  pname = "website";
  version = "stable";
  src = ./.;

  nativeBuildInputs = [
    pkgs.zola
    (pkgs.python3.withPackages (python: [python.fonttools python.brotli]))
  ];
  installPhase = "cp -r public $out";
  buildPhase = ''
    zola build ${
      if (site != null)
      then "--base-url " + site
      else ""
    }
    python3 scripts/optimize_fonts.py public
  '';

  meta = {
    description = "My Personal Website";
    license = lib.licenses.gpl3Only;
    maintainers = ["maydayv7"];
  };
}

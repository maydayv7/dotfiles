{
  lib,
  pkgs,
  files,
  ...
}:
pkgs.stdenv.mkDerivation rec {
  pname = "Dotfiles";
  version = "v11";
  longVersion = "22.07";

  src = files.path.toplevel;
  dontBuild = true;
  installPhase = "mkdir -p $out/ && cp -r . $out/";

  meta = with lib; {
    description = "My PC Dotfiles";
    homepage = files.path.repo;
    license = licenses.mit;
    maintainers = ["maydayv7"];
  };
}

{
  lib,
  pkgs,
  files,
  ...
}:
pkgs.stdenv.mkDerivation rec {
  pname = "Dotfiles";
  version = "v12";
  longVersion = "23.05";

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

{ lib, pkgs, files, ... }:
with pkgs;
stdenv.mkDerivation rec {
  pname = "Dotfiles";
  version = "v5.0";
  longVersion = "20220220";

  src = files.path.toplevel;
  dontBuild = true;
  installPhase = "mkdir -p $out/ && cp -r . $out/";

  meta = with lib; {
    description = "My PC Dotfiles";
    homepage = files.path.repo;
    license = licenses.mit;
    maintainers = [ "maydayv7" ];
  };
}

{ lib, pkgs, files, ... }:
with pkgs;
stdenv.mkDerivation rec {
  pname = "Dotfiles";
  version = "v1.0";

  src = files.toplevel;
  dontBuild = true;
  installPhase = "mkdir -p $out/ && cp -r * $out/";

  meta = with lib; {
    description = "My PC Dotfiles";
    license = licenses.mit;
    maintainers = with maintainers; [ maydayv7 ];
  };
}

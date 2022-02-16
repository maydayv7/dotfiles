{ lib, pkgs, ... }:
with pkgs;
let metadata = import ./metadata.nix;
in stdenv.mkDerivation rec {
  pname = "firefox-gnome-theme";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = pname;
    inherit (metadata) rev sha256;
  };

  dontBuild = true;
  installPhase = "mkdir -p $out/ && cp -r . $out/";

  meta = with lib; {
    description = "A GNOME Theme for Firefox";
    homepage = metadata.repo;
    license = licenses.unlicense;
    maintainers = [ "maydayv7" ];
  };
}

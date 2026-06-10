{
  lib,
  pkgs,
  ...
}:
with pkgs; let
  metadata = import ./metadata.nix;
in
  stdenv.mkDerivation rec {
    pname = "KvLibadwaita";
    version = metadata.rev;

    src = fetchFromGitHub {
      owner = "GabePoel";
      repo = pname;
      inherit (metadata) rev sha256;
    };

    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/Kvantum/
      cp -r ./src/. $out/share/Kvantum/
    '';

    meta = with lib; {
      description = "Libadwaita style theme for Kvantum";
      homepage = metadata.repo;
      license = licenses.gpl3Only;
      maintainers = ["maydayv7"];
    };
  }

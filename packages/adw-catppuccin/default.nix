{
  lib,
  pkgs,
  ...
}:
with pkgs; let
  metadata = import ./metadata.nix;
in
  stdenv.mkDerivation {
    pname = "adw-catppuccin";
    version = metadata.rev;

    src = fetchFromGitHub {
      owner = "LuminarLeaf";
      repo = "adw-catppuccin";
      inherit (metadata) rev sha256;
    };

    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/adw-catppuccin
      cp -r ./themes/. $out/share/adw-catppuccin/
    '';

    meta = {
      description = "Catppuccin port for Adwaita, compatible with libadwaita and adw-gtk3";
      homepage = metadata.repo;
      license = lib.licenses.gpl3Only;
      maintainers = ["maydayv7"];
    };
  }

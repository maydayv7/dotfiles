{
  lib,
  pkgs,
  ...
}:
with pkgs; let
  metadata = import ./metadata.nix;
  addonId = "ImportExportToolsNG@cleidigh.kokkini.net";
in
  stdenvNoCC.mkDerivation rec {
    pname = "thunderbird-importexporttools-ng";
    version = lib.removePrefix "v" metadata.rev;

    src = fetchurl {
      url = "${metadata.repo}/releases/download/v${version}/import-export-tools-ng-${version}-tb.xpi";
      inherit (metadata) sha256;
    };

    preferLocalBuild = true;
    dontUnpack = true;

    installPhase = ''
      runHook preInstall
      dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
      mkdir -p "$dst"
      install -v -m644 "$src" "$dst/${addonId}.xpi"
      runHook postInstall
    '';

    meta = with lib; {
      description = "Import/Export tools for messages and folders in Thunderbird";
      homepage = metadata.repo;
      license = licenses.gpl3Only;
      maintainers = ["maydayv7"];
    };
  }

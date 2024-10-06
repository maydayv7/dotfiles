{
  lib,
  pkgs,
  ...
}:
with pkgs; let
  name = "tilingshell";
  uuid = "${name}@ferrarodomenico.com";
in
  stdenv.mkDerivation rec {
    pname = "gnome-${name}";
    version = "v30";

    src = fetchzip {
      stripRoot = false;
      url = "https://extensions.gnome.org/extension-data/tilingshellferrarodomenico.com.${version}.shell-extension.zip";
      sha256 = "sha256-oU8KC6Q3QpycPVMcVcpMnA35YyNyLF6Xl3YbTiGKKHw=";
    };

    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/gnome-shell/extensions/${uuid}/
      cp -r . $out/share/gnome-shell/extensions/${uuid}/
    '';

    passthru = {
      extensionUuid = uuid;
      extensionPortalSlug = name;
    };

    meta = with lib; {
      description = "Extend GNOME Shell with advanced tiling window management";
      homepage = "https://extensions.gnome.org/extension/7065/tiling-shell/";
      license = licenses.gpl2;
      platforms = platforms.linux;
      maintainers = ["maydayv7"];
    };
  }

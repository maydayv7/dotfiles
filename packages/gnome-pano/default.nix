{
  lib,
  pkgs,
  ...
}:
with pkgs; let
  uuid = "pano@elhan.io";
in
  stdenv.mkDerivation rec {
    pname = "pano";
    version = "v23-alpha3";
    src = fetchzip {
      url = "https://github.com/oae/gnome-shell-pano/releases/download/${version}/${uuid}.zip";
      sha256 = "sha256-LYpxsl/PC8hwz0ZdH5cDdSZPRmkniBPUCqHQxB4KNhc=";
      stripRoot = false;
    };

    patches = [
      (substituteAll {
        src = ./imports.patch;
        inherit gsound libgda;
      })
    ];

    nativeBuildInputs = [wrapGAppsHook];
    buildInputs = [gnome-shell libgda gsound];
    installPhase = ''
      mkdir -p $out/share/gnome-shell/extensions
      cp -r -T . $out/share/gnome-shell/extensions/${uuid}
    '';

    passthru = {
      extensionPortalSlug = pname;
      extensionUuid = uuid;
    };

    meta = with lib; {
      description = "Mext-gen GNOME Shell Clipboard Management Extension";
      homepage = "https://github.com/oae/gnome-shell-pano";
      license = licenses.gpl2Plus;
      platforms = platforms.linux;
      maintainers = ["maydayv7"];
    };
  }

{
  lib,
  pkgs,
  ...
}:
with pkgs;
  stdenvNoCC.mkDerivation rec {
    pname = "adw-gtk3";
    version = "v4.2";

    src = fetchFromGitHub {
      owner = "lassekongo83";
      repo = pname;
      rev = version;
      sha256 = "sha256-dHSYm52+Wra5rh756sOuAlaKoQtkT8bSNGVnbINy8jA=";
    };

    nativeBuildInputs = [
      meson
      ninja
      sassc
    ];

    postPatch = ''
      chmod +x gtk/src/adw-gtk3-dark/gtk-3.0/install-dark-theme.sh
      patchShebangs gtk/src/adw-gtk3-dark/gtk-3.0/install-dark-theme.sh
    '';

    passthru = {
      updateScript = nix-update-script {
        attrPath = pname;
      };
    };

    meta = with lib; {
      description = "The theme from libadwaita ported to GTK-3";
      homepage = "https://github.com/lassekongo83/adw-gtk3";
      license = licenses.lgpl21Only;
      platforms = platforms.linux;
      maintainers = ["maydayv7"];
    };
  }

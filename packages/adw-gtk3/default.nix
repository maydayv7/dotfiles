{
  lib,
  pkgs,
  ...
}:
with pkgs; let
  metadata = import ./metadata.nix;
in
  stdenvNoCC.mkDerivation rec {
    pname = "adw-gtk3";
    version = metadata.rev;

    src = fetchFromGitHub {
      owner = "lassekongo83";
      repo = pname;
      inherit (metadata) rev sha256;
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
      homepage = metadata.repo;
      license = licenses.lgpl21Only;
      platforms = platforms.linux;
      maintainers = ["maydayv7"];
    };
  }

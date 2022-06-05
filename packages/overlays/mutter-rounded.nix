final: prev: {
  # GNOME Mutter Rounded Corners Patch
  # https://aur.archlinux.org/packages/mutter-rounded
  gnome =
    prev.gnome
    // {
      mutter =
        final.lib.overrideDerivation prev.gnome.mutter
        (drv: let
          commit = "7a7fd26eea94962ea9af13443abfdc3f5cfe6b37";
        in rec {
          assets = prev.fetchurl {
            url = "https://aur.archlinux.org/cgit/aur.git/snapshot/aur-${commit}.tar.gz";
            sha256 = "sha256-FaLKrNcIHZFW1EU4lWzyHMU+i3Ci6trAFV37WTaBObQ=";
          };

          postUnpack = ''
            tar xzf ${assets}
            find ./aur-${commit} -iregex ".*\.[ch].*" -exec cp {} $sourceRoot/src/ \;
          '';

          patches =
            drv.patches
            ++ [
              (prev.fetchpatch {
                name = "mr1441.patch";
                sha256 = "sha256-1mAphPV1W0vDr9ga6QTYgd82ObiiFIqzzm2Q7sNEgmc=";
                url = "https://aur.archlinux.org/cgit/aur.git/plain/mr1441.patch?h=mutter-rounded&id=${commit}";
              })
              (prev.fetchpatch {
                name = "rounded_corners.patch";
                sha256 = "sha256-rY2P1UJil0oP1lz0qcYJL2HSPJrMgFJzHw+QUsHhB8U=";
                url = "https://aur.archlinux.org/cgit/aur.git/plain/rounded_corners.patch?h=mutter-rounded&id=${commit}";
              })
              (prev.fetchpatch {
                name = "shell_blur_effect.patch";
                sha256 = "sha256-ZR4Lh6XyBhF35SIz1537pvrjtXQuNkY6nffKqPOQ2eI=";
                url = "https://aur.archlinux.org/cgit/aur.git/plain/shell_blur_effect.patch?h=mutter-rounded&id=${commit}";
              })
            ];
        });
    };
}

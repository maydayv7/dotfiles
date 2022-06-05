final: prev: {
  # GNOME Terminal Transparency Patch
  # https://aur.archlinux.org/packages/gnome-terminal-transparency
  gnome =
    prev.gnome
    // {
      gnome-terminal =
        final.lib.overrideDerivation prev.gnome.gnome-terminal
        (drv: {
          patches =
            drv.patches
            ++ [
              (prev.fetchpatch {
                name = "transparency.patch";
                sha256 = "sha256-vQ/xHgbfp03zp4b/llfP2MRgC15NR3XGkRm26hfN8Ow=";
                url = "https://aur.archlinux.org/cgit/aur.git/plain/transparency.patch?h=gnome-terminal-transparency&id=eb672d7753287b88c5fe2557566fd4611c8c0a38";
              })
            ];
        });
    };
}

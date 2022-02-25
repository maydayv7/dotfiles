final: prev: {
  # GNOME Terminal Transparency Patch
  # https://aur.archlinux.org/packages/gnome-terminal-transparency
  gnome =
    prev.gnome
    // {
      gnome-terminal = final.lib.overrideDerivation prev.gnome.gnome-terminal
      (drv: {
        patches =
          drv.patches
          ++ [
            (prev.fetchpatch {
              name = "transparency.patch";
              sha256 = "0y116dww3j1mk4s2qklkgw8jjmvdfdpwynbijq0iwazvlggmsilk";
              url = "https://aur.archlinux.org/cgit/aur.git/plain/transparency.patch?h=gnome-terminal-transparency&id=7dd7cd2471e42af8130cda7905b2b2c2a334ac4b";
            })
          ];
      });
    };
}

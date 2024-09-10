final: prev: {
  ## GNOME Desktop Patches
  gnome = prev.gnome.overrideScope (_: gprev: {
    # Mutter WM X11 Improvements
    # https://aur.archlinux.org/packages/mutter-x11-scaling
    mutter = gprev.mutter.overrideAttrs (old: {
      patches =
        if old.version == "46.2"
        then
          (
            (old.patches or [])
            ++ [
              (prev.fetchpatch {
                url = "https://raw.githubusercontent.com/puxplaying/mutter-x11-scaling/7aa432d4366fdd5a2687a78848b25da4f8ab5c68/x11-Add-support-for-fractional-scaling-using-Randr.patch";
                hash = "sha256-HdBE9uiFBTqWU1fE0n0XFYObqX3R/+itCxFvsUnA554=";
              })
              (prev.fetchpatch {
                url = "https://raw.githubusercontent.com/puxplaying/mutter-x11-scaling/eff4767168c107ef268c7e8b32eaea41a224efb4/mutter-fix-x11-restart.patch";
                hash = "sha256-hSqmi4PEAXgLPN3t8/cKP65F9Pmhgpfxm+VzfT0upx8=";
              })
            ]
          )
        else throw "Update GNOME Mutter patchset to latest version";
    });
  });
}

_: prev: {
  # ! # https://gitlab.gnome.org/GNOME/gnome-keyring/-/merge_requests/112
  gnome-keyring = prev.gnome-keyring.overrideAttrs (old: {
    patches =
      (old.patches or [])
      ++ [
        (prev.fetchurl {
          url = "https://gitlab.gnome.org/GNOME/gnome-keyring/-/commit/c06dd839a40517c5c0470fd492d2b07ce1356d2e.patch";
          hash = "sha256-Ejqu51qnxuXWfIzx88iaFklvFTWQSZowEmUez1QT2Rs=";
        })
        (prev.fetchurl {
          url = "https://gitlab.gnome.org/GNOME/gnome-keyring/-/commit/8fcdeffe67ae8c1600eae9637816acbf73f66b81.patch";
          hash = "sha256-vDLeiHFatIQ/Df8HB7wTPwQtsxzVYXwdwL6Uo99j42M=";
        })
      ];
  });
}

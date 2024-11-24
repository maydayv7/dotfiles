pkgs: rec {
  # Theming
  name = "catppuccin";
  name-alt = "Catppuccin";

  accent = "blue";
  variant = "macchiato";
  variant-alt = "Macchiato";

  gtk = {
    name = "${name}-${variant}-${accent}-standard";
    package = pkgs.catppuccin-gtk.override {
      accents = [accent];
      inherit variant;
    };
  };

  qt = {
    name = "${name}-${variant}-${accent}";
    package = pkgs.catppuccin-kvantum.override {
      inherit accent variant;
    };
  };

  icons = {
    name = "Papirus-Dark";
    package = pkgs.catppuccin-papirus-folders.override {
      inherit accent;
      flavor = variant;
    };
  };
}

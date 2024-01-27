pkgs: rec {
  # Theming
  name = "catppuccin";
  name-alt = "Catppuccin";

  accent = "blue";
  accent-alt = "Blue";

  variant = "macchiato";
  variant-alt = "Macchiato";

  gtk = {
    name = "${name-alt}-${variant-alt}-Standard-${accent-alt}-Dark";
    package = pkgs.catppuccin-gtk.override {
      accents = [accent];
      inherit variant;
    };
  };

  qt = {
    name = "${name-alt}-${variant-alt}-${accent-alt}";
    package = pkgs.catppuccin-kvantum.override {
      accent = accent-alt;
      variant = variant-alt;
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

{ config, lib, pkgs, ... }:
{
  ## Desktop Theming ##
  # GTK+
  gtk =
  {
    enable = true;
    theme =
    {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };
    iconTheme =
    {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };
  
  home.file =
  {
    # Custome GNOME Shell Theme
    ".themes/Adwaita/gnome-shell/gnome-shell.css".source = ./theme;
       
    # gEdit Color Scheme
    ".local/share/gtksourceview-4/styles/tango-dark.xml".source = ./colors;
    ".local/share/gtksourceview-4/language-specs/nix.lang".source = ./syntax;
  };
}

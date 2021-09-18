{ config, lib, pkgs, ... }:
{
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
}

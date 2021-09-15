{ config, lib, pkgs, ... }:
{
  # Theming
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
  
  qt =
  {
    enable = true;
    platformTheme = "gnome";
    style =
    {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };
}

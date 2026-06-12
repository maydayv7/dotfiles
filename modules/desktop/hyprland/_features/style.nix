# Desktop integration: theme data, GTK/QT, stylix scheme
{
  files ? null,
  theme ? null,
  ...
}: {
  nixos = {pkgs, ...}: let
    inherit (theme) accent variant;

    gtk = {
      name = "catppuccin-${variant}-${accent}-standard";
      package = pkgs.catppuccin-gtk.override {
        accents = [accent];
        inherit variant;
      };
    };

    qt = {
      name = "catppuccin-${variant}-${accent}";
      package = pkgs.catppuccin-kvantum.override {
        inherit accent variant;
      };
    };

    icons = {
      name = theme.icons;
      package = pkgs.catppuccin-papirus-folders.override {
        inherit accent;
        flavor = variant;
      };
    };
  in {
    stylix.base16Scheme = files.colors.catppuccin;
    environment.systemPackages = [pkgs.custom.cursors];

    gui = {
      inherit icons;
      gtk.theme = gtk;
      qt = {
        theme = qt;
        style = "kvantum";
      };
    };
  };

  # GTK Apps
  home.dconf.settings."org/gnome/desktop/wm/preferences" = {
    action-double-click-titlebar = "none";
    button-layout = "appmenu";
  };
}

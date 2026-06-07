{
  config,
  lib,
  pkgs,
  files,
  ...
}:
let
  inherit (config._shared) enable theme;
  inherit (theme) icons gtk qt;
in
{
  ## Desktop Integration
  config = lib.mkIf enable {
    stylix.base16Scheme = files.colors.catppuccin;
    environment.systemPackages = [ pkgs.custom.cursors ];
    gui = {
      inherit icons;

      gtk = {
        enable = true;
        theme = gtk;
      };

      qt = {
        enable = true;
        theme = qt;
        style = "kvantum";
      };
    };

    # GTK Apps
    user.homeConfig.dconf.settings."org/gnome/desktop/wm/preferences" = {
      action-double-click-titlebar = "none";
      button-layout = "appmenu";
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.gui.qt;
in {
  options.gui.qt = {
    enable = mkEnableOption "Enable QT Configuration";
    theme = {
      name = mkOption {
        description = "QT Application Theme";
        type = types.str;
      };

      package = mkOption {
        description = "QT Theme Package";
        type = types.package;
      };
    };
  };

  ## QT Configuration ##
  config = mkIf cfg.enable {
    environment = {
      systemPackages = [pkgs.libsForQt5.qtstyleplugin-kvantum cfg.theme.package];
      variables."QT_STYLE_OVERRIDE" = "kvantum";
      etc."xdg/Kvantum/kvantum.kvconfig".text = ''
        [General]
        Theme=${cfg.theme.name}
      '';
    };
  };
}

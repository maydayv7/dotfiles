{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.gui.qt;
  kvconfig = ''
    [General]
    theme=${cfg.theme.name}
  '';
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
      etc."xdg/Kvantum/kvantum.kvconfig".text = kvconfig;
    };

    user.homeConfig = {
      qt = {
        enable = true;
        platformTheme = "qtct";
        style.name = "kvantum";
      };

      xdg.configFile = with cfg.theme; {
        "Kvantum/${name}".source = "${package}/share/Kvantum/${name}";
        "Kvantum/kvantum.kvconfig".text = kvconfig;
      };
    };
  };
}

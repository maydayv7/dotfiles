{
  config,
  lib,
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
  config = with cfg.theme;
    mkIf cfg.enable {
      qt = {
        enable = true;
        platformTheme = "qt5ct";
        style = "kvantum";
      };

      environment = {
        systemPackages = [package];
        etc."xdg/Kvantum/kvantum.kvconfig".text = ''
          [General]
          Theme=${name}
        '';
      };

      user.homeConfig = {
        qt = {
          enable = true;
          platformTheme.name = "qtct";
          style.name = "kvantum";
        };

        xdg.configFile = {
          "Kvantum/${name}".source = "${package}/share/Kvantum/${name}";
          "Kvantum/kvantum.kvconfig".text = ''
            [General]
            theme=${name}
          '';
        };
      };
    };
}

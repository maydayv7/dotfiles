## QT Configuration ##
_: {
  flake.modules = {
    nixos.qt = {
      config,
      lib,
      pkgs,
      ...
    }: let
      inherit (lib) mkOption types;
      cfg = config.gui.qt;
    in {
      options.gui.qt = {
        theme = mkOption {
          description = "QT Application Theme";
          type = types.str;
          default = "";
        };

        package = mkOption {
          description = "QT Theme Package";
          type = types.package;
          default = pkgs.adwaita-qt;
        };
      };

      # Kvantum Style
      config = {
        stylix.targets.qt.enable = false;
        qt = {
          enable = true;
          platformTheme = "qt5ct";
          style = "kvantum";
        };

        environment = {
          systemPackages = [
            cfg.package
            pkgs.libsForQt5.qt5ct
            pkgs.kdePackages.qt6ct
          ];

          etc."xdg/Kvantum/kvantum.kvconfig".text = ''
            [General]
            theme=${cfg.theme}
          '';
        };
      };
    };

    homeManager.qt = {
      config,
      lib,
      osConfig ? {},
      ...
    }: let
      inherit (builtins) concatStringsSep map;
      cfg = osConfig.gui.qt or {};
    in {
      gui._unmanaged = ["qt"];
      xdg.configFile."Kvantum" = lib.mkIf (cfg ? package) {
        source = "${cfg.package}/share/Kvantum";
        recursive = true;
      };

      # KDE Apps
      home.file.".config/kdeglobals".text = with config.lib.stylix.colors;
        ''
          [Colors:Selection]
          BackgroundNormal=${base0D-rgb-r},${base0D-rgb-g},${base0D-rgb-b}
          BackgroundAlternate=${base0D-rgb-r},${base0D-rgb-g},${base0D-rgb-b}
          ForegroundNormal=${base00-rgb-r},${base00-rgb-g},${base00-rgb-b}
          ForegroundActive=${base00-rgb-r},${base00-rgb-g},${base00-rgb-b}
          ForegroundInactive=${base00-rgb-r},${base00-rgb-g},${base00-rgb-b}
          ForegroundLink=${base00-rgb-r},${base00-rgb-g},${base00-rgb-b}
          ForegroundVisited=${base00-rgb-r},${base00-rgb-g},${base00-rgb-b}
        ''
        + (concatStringsSep "\n" (
          map
          (name: ''
            [Colors:${name}]
            BackgroundNormal=${base00-rgb-r},${base00-rgb-g},${base00-rgb-b}
            BackgroundAlternate=${base01-rgb-r},${base01-rgb-g},${base01-rgb-b}
            DecorationFocus=${base0D-rgb-r},${base0D-rgb-g},${base0D-rgb-b}
            DecorationHover=${base0D-rgb-r},${base0D-rgb-g},${base0D-rgb-b}
            ForegroundNormal=${base05-rgb-r},${base05-rgb-g},${base05-rgb-b}
            ForegroundActive=${base05-rgb-r},${base05-rgb-g},${base05-rgb-b}
            ForegroundInactive =${base05-rgb-r},${base05-rgb-g},${base05-rgb-b}
            ForegroundLink=${base05-rgb-r},${base05-rgb-g},${base05-rgb-b}
            ForegroundVisited=${base05-rgb-r},${base05-rgb-g},${base05-rgb-b}
            ForegroundNegative=${base08-rgb-r},${base08-rgb-g},${base08-rgb-b}
            ForegroundNeutral=${base0D-rgb-r},${base0D-rgb-g},${base0D-rgb-b}
            ForegroundPositive=${base0B-rgb-r},${base0B-rgb-g},${base0B-rgb-b}
          '')
          [
            "View"
            "Window"
            "Button"
            "Tooltip"
            "Complementary"
          ]
        ));
    };
  };
}

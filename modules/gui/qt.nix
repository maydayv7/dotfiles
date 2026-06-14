## QT Configuration ##
_: {
  flake.modules = {
    nixos.qt = {
      config,
      lib,
      pkgs,
      ...
    }: let
      inherit
        (lib)
        mkDefault
        mkIf
        mkMerge
        mkOption
        types
        ;
      inherit (config.gui) qt icons;
      inherit (config.stylix) fonts;
    in {
      options.gui.qt = {
        style = mkOption {
          description = "QT Application Style";
          type = types.nullOr (
            types.enum [
              "gtk"
              "kvantum"
              "qtct"
            ]
          );
          default = null;
        };

        theme = {
          name = mkOption {
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
      };

      config = with qt.theme;
        mkMerge [
          {
            stylix.targets.qt.enable = false;
            qt = {
              enable = true;
              platformTheme = mkDefault "gtk2";
            };
          }

          (mkIf (qt.style == "gtk") {
            qt = {
              platformTheme = "gnome";
              style = "adwaita-dark";
            };
          })

          (mkIf (qt.style == "kvantum") {
            qt = {
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
          })

          (mkIf (qt.style == "qtct") (
            let
              pkg = with pkgs; [
                darkly
                darkly-qt5
              ];

              conf = version:
                lib.generators.toINI {} {
                  Appearance = {
                    style = "Lightly";
                    standard_dialogs = "default";
                    icon_theme = icons.name;
                    custom_palette = true;
                    color_scheme_path = "${package}/share/${version}/colors/${name}.conf";
                  };

                  Fonts = let
                    size = fonts.sizes.applications;
                  in {
                    fixed = "\"${fonts.monospace.name},${size},-1,5,50,0,0,0,0,0,Regular\"";
                    general = "\"${fonts.sansSerif.name},${size},-1,5,50,0,0,0,0,0,Regular\"";
                  };
                };
            in {
              qt.platformTheme = "qt5ct";
              environment = {
                systemPackages = pkg;
                etc = {
                  "xdg/qt5ct/qt5ct.conf".text = conf "qt5ct";
                  "xdg/qt6ct/qt6ct.conf".text = conf "qt6ct";
                };
              };
            }
          ))
        ];
    };

    homeManager.qt = {config, ...}: let
      inherit (builtins) concatStringsSep map;
    in {
      stylix.targets.qt.enable = false;

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

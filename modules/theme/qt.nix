# QT application theming
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
        mkEnableOption
        mkIf
        mkMerge
        mkOption
        types
        ;
      inherit (config.gui) qt icons;
      inherit (config.stylix) fonts;
    in {
      options.gui.qt = {
        enable = mkEnableOption "Enable QT Configuration";
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
        mkIf qt.enable (mkMerge [
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
        ]);
    };
  };
}

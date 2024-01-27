{
  config,
  lib,
  inputs,
  pkgs,
  files,
  ...
}: let
  inherit (lib) attrNames hasSuffix mkIf mkOption optionals types;
  cfg = config.gui;
  enable = !(cfg.desktop == "" || hasSuffix "-minimal" cfg.desktop);
  exists = app: builtins.elem app config.apps.list;
in {
  imports = [inputs.stylix.nixosModules.stylix];

  options.gui = {
    theme = {
      name = mkOption {
        description = "GUI Application Theme";
        type = types.str;
      };

      package = mkOption {
        description = "Theme Package";
        type = types.package;
      };
    };

    icons = {
      name = mkOption {
        description = "Application Icons Theme";
        type = types.str;
        default = "Papirus-Dark";
      };

      package = mkOption {
        description = "Icons Package";
        type = types.package;
        default = pkgs.papirus-icon-theme;
      };
    };

    cursors = {
      name = mkOption {
        description = "GUI Cursors Theme";
        type = types.str;
        default = "Bibata-Original-Classic";
      };

      package = mkOption {
        description = "Cursors Package";
        type = types.package;
        default = pkgs.bibata-cursors;
      };
    };

    wallpaper = mkOption {
      description = "Desktop Wallpaper Choice";
      type = types.enum (attrNames files.wallpapers);
      default = "Beauty";
      apply = image: files.wallpapers."${image}";
    };
  };

  ## Application Theming ##
  config = rec {
    environment.systemPackages =
      [stylix.cursor.package]
      ++ optionals enable [cfg.theme.package cfg.icons.package cfg.cursors.package];
    stylix =
      {
        autoEnable = false;
        image = cfg.wallpaper;
        cursor = cfg.cursors // {size = 28;};
      }
      // (
        if (!enable)
        then {
          homeManagerIntegration.autoImport = false;
        }
        else {
          homeManagerIntegration.autoImport = true;
          polarity = "dark";
          targets = {
            console.enable = true;
            kmscon.enable = true;
            plymouth.enable = false;
          };
        }
      );

    user.homeConfig.stylix.targets = {
      bat.enable = true;
      vscode.enable = mkIf (exists "vscode") false;
    };
  };
}

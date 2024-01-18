{
  config,
  lib,
  inputs,
  pkgs,
  files,
  ...
}: let
  inherit (lib) attrNames hasSuffix mkIf mkOption optional types;
  cfg = config.gui;
  enable = !(cfg.desktop == "" || hasSuffix "-minimal" cfg.desktop);
  exists = app: builtins.elem app config.apps.list;
in {
  imports = [inputs.stylix.nixosModules.stylix];

  options.gui.wallpaper = mkOption {
    description = "Desktop Wallpaper Choice";
    type = types.enum (attrNames files.wallpapers);
    default = "Beauty";
    apply = image: files.wallpapers."${image}";
  };

  ## Base16 Color Theming ##
  config = rec {
    environment.systemPackages = [stylix.cursor.package] ++ optional enable pkgs.papirus-icon-theme;
    stylix =
      {
        autoEnable = false;
        image = cfg.wallpaper;
        cursor = {
          package = pkgs.bibata-cursors;
          name = "Bibata-Original-Classic";
          size = 28;
        };
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

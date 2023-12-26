{
  config,
  lib,
  inputs,
  pkgs,
  files,
  ...
}: let
  inherit (lib) attrNames hasSuffix mkOption types;
  cfg = config.gui;
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
    environment.systemPackages = [stylix.cursor.package];
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
        if (cfg.desktop == "" || hasSuffix "-minimal" cfg.desktop)
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
      vscode.enable = false;
    };
  };
}

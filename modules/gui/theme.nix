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
  enable = !(cfg.desktop == "" || hasSuffix "-iso" cfg.desktop);
  exists = app: builtins.elem app config.apps.list;
in {
  imports = [inputs.stylix.nixosModules.stylix];

  options.gui = {
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

      size = mkOption {
        description = "Cursors Size";
        type = types.int;
        default = 28;
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
      ++ optionals enable [cfg.icons.package cfg.cursors.package];

    stylix = {
      inherit enable;
      autoEnable = true;
      image = cfg.wallpaper;
      cursor = cfg.cursors;
      polarity = "dark";
      opacity = {
        popups = 0.9;
        terminal = 0.9;
      };

      homeManagerIntegration.autoImport = true;
      targets.plymouth.enable = false;
    };

    user.homeConfig.stylix.targets = {
      firefox.enable = false;
      vscode.enable = mkIf (exists "vscode") false;
    };
  };
}

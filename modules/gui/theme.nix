## System Theming ##
{
  config,
  inputs,
  ...
}: let
  inherit (config.flake) files;
in {
  flake.modules = {
    nixos.theme = {
      config,
      lib,
      pkgs,
      ...
    }: let
      inherit
        (lib)
        attrNames
        mkOption
        optionals
        types
        ;
      cfg = config.gui;
      inherit (config.gui) enable;
    in {
      imports = [inputs.stylix.nixosModules.stylix];

      options.gui = {
        enable = lib.mkEnableOption "Graphical Desktop Session";
        fancy = lib.mkEnableOption "Enable Fancy GUI Effects";
        display = mkOption {
          description = "Main GUI Display";
          type = types.str;
          default = "eDP-1";
          example = "HDMI-A-1";
        };

        icons = {
          name = mkOption {
            type = types.str;
            default = "Papirus-Dark";
          };
          package = mkOption {
            type = types.package;
            default = pkgs.papirus-icon-theme;
          };
        };
        cursors = {
          name = mkOption {
            type = types.str;
            default = "Bibata-Original-Classic";
          };
          package = mkOption {
            type = types.package;
            default = pkgs.bibata-cursors;
          };
          size = mkOption {
            type = types.int;
            default = 28;
          };
        };
        wallpaper = mkOption {
          type = types.enum (attrNames files.wallpapers);
          default = "Beauty";
          apply = image: files.wallpapers."${image}";
        };
      };

      config = {
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
          targets = {
            console.enable = true;
            plymouth.enable = false;
            chromium.enable = false;
          };
        };

        home-manager.sharedModules = optionals (!enable) [
          config.stylix.homeManagerIntegration.module
        ];

        environment.systemPackages =
          [config.stylix.cursor.package]
          ++ optionals enable [
            cfg.icons.package
            cfg.cursors.package
          ];

        programs.gnupg.agent.pinentryPackage = pkgs.pinentry-gtk2;
      };
    };

    homeManager.theme = {lib, ...}: {
      config.stylix = {
        enable = lib.mkDefault true;
        icons = lib.mkForce {
          enable = true;
          light = "Papirus-Dark";
          dark = "Papirus-Dark";
        };
        targets = {
          firefox.enable = false;
          gnome.enable = lib.mkDefault false;
          spicetify.enable = false;
          vscode.enable = false;
        };
      };
    };
  };
}

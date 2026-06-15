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
      cfg = config.gui;
      stl = config.stylix;
      inherit (cfg) enable;
    in {
      imports = [inputs.stylix.nixosModules.stylix];

      options.gui = {
        enable = lib.mkEnableOption "Graphical Desktop Session";
        fancy = lib.mkEnableOption "Enable Fancy GUI Effects";
        display = lib.mkOption {
          description = "Main GUI Display";
          type = lib.types.str;
          default = "eDP-1";
          example = "HDMI-A-1";
        };
        wallpaper = lib.mkOption {
          type = lib.types.enum (lib.attrNames files.wallpapers);
          default = "Beauty";
          apply = image: files.wallpapers."${image}";
        };
      };

      config = {
        stylix = {
          inherit enable;
          autoEnable = true;
          homeManagerIntegration = {
            autoImport = true;
            followSystem = true;
          };

          image = cfg.wallpaper;
          polarity = "dark";

          icons = {
            enable = true;
            package = lib.mkDefault pkgs.papirus-icon-theme;
            light = "Papirus-Dark";
            dark = "Papirus-Dark";
          };

          cursor = {
            name = "Bibata-Original-Classic";
            package = pkgs.bibata-cursors;
            size = 28;
          };

          opacity = {
            popups = 0.9;
            terminal = 0.9;
          };

          targets = {
            console.enable = true;
            plymouth.enable = false;
            chromium.enable = false;
          };
        };

        home-manager.sharedModules = lib.optionals (!enable) [
          config.stylix.homeManagerIntegration.module
        ];

        environment.systemPackages = lib.optionals enable [
          stl.icons.package
          stl.cursor.package
        ];

        programs.gnupg.agent.pinentryPackage = pkgs.pinentry-gtk2;
      };
    };

    homeManager.theme = {lib, ...}: {
      config.stylix = {
        enable = lib.mkDefault true;
        targets = {
          firefox.enable = lib.mkDefault false;
          gnome.enable = lib.mkDefault false;
          spicetify.enable = false;
          vscode.enable = false;
        };
      };
    };
  };
}

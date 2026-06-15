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
          homeManagerIntegration = {
            autoImport = true;
            followSystem = true;
          };

          image = cfg.wallpaper;
          polarity = "dark";

          icons = {
            enable = true;
            package = pkgs.papirus-icon-theme;
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

        home-manager.sharedModules = optionals (!enable) [
          config.stylix.homeManagerIntegration.module
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

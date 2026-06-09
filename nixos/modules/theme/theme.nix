# Stylix theming, GTK, QT, icons, cursors, wallpaper
## Application Theming ##
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
      enable = cfg.desktop or "" != "" && cfg.desktop or "" != "install";
    in {
      imports = [inputs.stylix.nixosModules.stylix];

      options.gui = {
        fancy = lib.mkEnableOption "Enable Fancy GUI Effects";
        display = mkOption {
          description = "Main GUI Display";
          type = types.str;
          default = "eDP-1";
          example = "HDMI-A-1";
        };
        desktop = mkOption {
          description = "GUI Desktop Choice";
          type = types.enum [
            ""
            "install"
            "gnome"
            "hyprland"
            "niri"
            "pantheon"
          ];
          default = "";
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
        # Environment Setup
        programs.dconf.enable = true;
        services.dbus.packages = [pkgs.dconf];

        environment.systemPackages =
          [
            config.stylix.cursor.package
          ]
          ++ optionals enable [
            cfg.icons.package
            cfg.cursors.package
          ];

        # Desktop Integration
        programs.gnupg.agent.pinentryPackage = pkgs.pinentry-gtk2;

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
      };
    };

    homeManager.theme = {lib, ...}: {
      home.persist.directories = [
        ".config/dconf"
        ".config/gtk-3.0"
        ".config/gtk-4.0"
      ];

      stylix = {
        enable = lib.mkDefault true;
        icons = lib.mkForce {
          enable = true;
          light = "Papirus-Dark";
          dark = "Papirus-Dark";
        };
        targets = {
          firefox.enable = false;
          gtk.enable = false;
          gnome.enable = lib.mkDefault false;
          spicetify.enable = false;
          vscode.enable = false;
        };
      };

      # Theming
      dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
      gtk = {
        enable = true;
        gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
        gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
      };
    };
  };
}

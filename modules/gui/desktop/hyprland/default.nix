{
  config,
  lib,
  pkgs,
  files,
  ...
} @ args: let
  inherit (config.gui) desktop;
  inherit (lib) mkIf mkMerge;
  theme = import ./theme.nix pkgs;
in {
  ## Hyprland Configuration ##
  config = mkIf (desktop == "hyprland" || desktop == "hyprland-minimal") (mkMerge [
    {
      # Session
      gui = {
        xorg.enable = false;
        wayland.enable = true;
      };

      programs = {
        hyprland = {
          enable = true;
          xwayland.enable = true;
          package = pkgs.hyprworld.hyprland;
        };

        regreet = {
          enable = true;
          package = pkgs.greetd.regreet.overrideAttrs (final: prev: {
            SESSION_DIRS = "${config.services.xserver.displayManager.sessionData.desktops}/share";
          });

          settings.commands = {
            reboot = ["systemctl" "reboot"];
            poweroff = ["systemctl" "poweroff"];
          };
        };
      };
    }

    (mkIf (desktop == "hyprland") (import ./apps args))
    (mkIf (desktop == "hyprland") {
      # Boot Splash
      boot.plymouth = {
        theme = with theme; "${name}-${variant}";
        themePackages = [(pkgs.catppuccin-plymouth.override {inherit (theme) variant;})];
      };

      # Settings
      user.homeConfig.imports = [./settings];

      # Desktop Integration
      stylix.base16Scheme = files.colors.catppuccin;
      gui = with theme; {
        fonts.enable = true;
        inherit (theme) icons;

        gtk = {
          enable = true;
          theme = gtk;
        };

        qt = {
          enable = true;
          theme = qt;
        };

        launcher = {
          enable = true;
          shadow = false;
          theme = theme.name;
        };
      };

      ## Essential Utilities
      xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
      services = {
        # Battery
        power-profiles-daemon.enable = true;
        upower.enable = true;

        # Location
        geoclue2.enable = true;
      };
      location.provider = "geoclue2";

      # Greeter
      programs.regreet.settings.GTK = with config.stylix; {
        application_prefer_dark_theme = true;
        cursor_theme_name = cursor.name;
        font_name = "${fonts.sansSerif.name} 16";
        icon_theme_name = theme.icons.name;
        theme_name = theme.gtk.name;
      };

      # Backlight
      user.groups = ["input" "video"];
      hardware.brillo.enable = true;

      # Security
      security.pam.services = {
        greetd.enableGnomeKeyring = true;
        swaylock.text = "auth include login";
      };
    })
  ]);
}

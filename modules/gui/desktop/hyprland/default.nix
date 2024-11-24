{
  config,
  lib,
  util,
  pkgs,
  files,
  ...
} @ args: let
  inherit (config.gui) desktop;
  inherit (lib) getExe mkForce mkIf mkMerge replaceStrings;
  theme = import ./theme.nix pkgs;
in {
  ## Hyprland Configuration ##
  config = mkIf (desktop == "hyprland") (mkMerge [
    ## Environment Setup
    rec {
      gui = {
        xorg.enable = false;
        wayland.enable = true;
        launcher = {
          enable = true;
          shadow = false;
        };
      };

      # Session
      services.xserver.displayManager.session = [
        {
          name = "Desktop";
          manage = "desktop";
          start = "Hyprland &> /dev/null";
        }
      ];

      programs = {
        # WM
        hyprland = {
          enable = true;
          xwayland.enable = true;
          package = pkgs.hyprworld.hyprland;
        };

        # Login
        regreet = {
          enable = true;
          package = pkgs.greetd.regreet;
          settings.commands = {
            reboot = ["systemctl" "reboot"];
            poweroff = ["systemctl" "poweroff"];
          };
        };
      };

      # Greeter
      services.greetd.settings.default_session.command = with programs;
        mkForce "${getExe hyprland.package} --config ${
          pkgs.writeText "greeter.conf"
          (replaceStrings ["@greeter"] [(getExe regreet.package)]
            (util.build.theme {
              inherit (config.lib.stylix) colors;
              file = files.hyprland.greeter;
            }))
        } &> /dev/null";
    }

    {
      # Boot Splash
      boot.plymouth = {
        theme = with theme; "${name}-${variant}";
        themePackages = [(pkgs.catppuccin-plymouth.override {inherit (theme) variant;})];
      };

      # Greeter
      environment.persist.directories = ["/var/cache/regreet"];
      stylix.targets.regreet.enable = true;
      programs.regreet = {
        extraCss = mkForce "";
        theme = mkForce theme.gtk;
        iconTheme = mkForce theme.icons;
      };
    }

    {
      # Settings
      user.persist.directories = [".config/hypr"];
      user.homeConfig.imports = [./settings];

      # Desktop Integration
      stylix.base16Scheme = files.colors.catppuccin;
      gui = with theme; {
        fonts.enable = true;
        inherit (theme) icons;
        launcher.theme = theme.name;

        gtk = {
          enable = true;
          theme = gtk;
        };

        qt = {
          enable = true;
          theme = qt;
        };
      };

      ## Essential Utilities
      xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
      services = {
        # Battery
        power-profiles-daemon.enable = true;
        upower.enable = true;

        # Location
        geoclue2 = {
          enable = true;
          geoProviderUrl = "https://beacondb.net/v1/geolocate";
        };
      };
      location.provider = "geoclue2";

      # Backlight
      user.groups = ["input" "video"];
      hardware.brillo.enable = true;

      # Security
      security.pam.services = {
        greetd.enableGnomeKeyring = true;
        swaylock.text = "auth include login";
      };
    }

    ## Application Configuration
    (import ./apps args)
  ]);
}

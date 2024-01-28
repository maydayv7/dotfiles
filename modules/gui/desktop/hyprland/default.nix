{
  config,
  lib,
  pkgs,
  files,
  ...
} @ args: let
  inherit (config.gui) desktop;
  inherit (config.stylix) cursor fonts;
  inherit (lib) mkIf mkMerge;
  theme = import ./theme.nix pkgs;
in {
  #!# WIP #!#
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
          package = pkgs.unstable.hyprland;
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

    (mkIf (desktop == "hyprland") (import ./apps.nix args))
    (mkIf (desktop == "hyprland") {
      # Boot Splash
      boot.plymouth = {
        theme = with theme; "${name}-${variant}";
        themePackages = [pkgs.catppuccin-plymouth];
      };

      # Desktop Integration
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
          terminal = "kitty";
        };
      };

      # Security
      security.pam.services = {
        greetd.enableGnomeKeyring = true;
        swaylock.text = "auth include login";
      };

      ## Essential Utilities
      xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

      # Battery
      services.power-profiles-daemon.enable = true;
      services.upower.enable = true;

      # Greeter
      programs.regreet.settings.GTK = {
        application_prefer_dark_theme = true;
        cursor_theme_name = cursor.name;
        font_name = "${fonts.sansSerif.name} 16";
        icon_theme_name = theme.icons.name;
        theme_name = theme.gtk.name;
      };

      # Backlight
      user.groups = ["video"];
      hardware.brillo.enable = true;
      services.clight = {
        enable = true;
        settings = {
          verbose = true;
          backlight.disabled = true;
          dpms.timeouts = [900 300];
          dimmer.timeouts = [870 270];
          gamma.long_transition = true;
          screen.disabled = true;
        };
      };

      # Location
      location.provider = "geoclue2";
      services.geoclue2.enable = true;

      # Color Scheme
      stylix.base16Scheme = files.colors.catppuccin;

      ## User Configuration
      user.homeConfig = {
        imports = [./binds.nix ./rules.nix];

        ## Settings
        wayland.windowManager.hyprland = {
          enable = true;
          settings = {
            env = ["QT_WAYLAND_DISABLE_WINDOWDECORATION,1"];
            debug.disable_logs = false;
            exec-once = [
              "hyprctl setcursor ${cursor.name} ${builtins.toString cursor.size}"
              "systemctl --user start clight"
            ];

            # Display
            monitor = ",preferred,auto,1";
            xwayland.force_zero_scaling = true;

            input = {
              # Keyboard
              kb_layout = "us";
              numlock_by_default = true;

              # Mouse
              follow_mouse = 1; # Focus on cursor move
              accel_profile = "flat";
              touchpad = {
                disable_while_typing = true;
                natural_scroll = true;
                tap-to-click = true;
                tap-and-drag = true;
              };
            };

            gestures = {
              workspace_swipe = true;
              workspace_swipe_fingers = 3;
              workspace_swipe_forever = true;
            };

            # Tiling Layout
            dwindle = {
              pseudotile = true; # Keep floating dimensions
              preserve_split = true;
            };

            misc = {
              enable_swallow = true;
              force_default_wallpaper = 0;

              # Prevent checking for configuration changes
              # Use 'hyprctl reload' if required
              disable_autoreload = true;

              # Graphics
              vrr = 1;
              no_direct_scanout = false;
            };

            general =
              {
                resize_on_border = true;
                allow_tearing = config.hardware.cpu.mode == "powersave";
              }
              //
              # Visuals
              {
                gaps_in = 5;
                gaps_out = 5;
                border_size = 3;
              };

            decoration = {
              rounding = 10;
              drop_shadow = true;
              shadow_ignore_window = true;
              shadow_offset = "0 2";
              shadow_range = 20;
              shadow_render_power = 3;

              blur = {
                enabled = true;
                brightness = 1.0;
                contrast = 1.0;
                noise = 0.02;
                passes = 3;
                size = 10;
              };
            };
          };
        };
      };
    })
  ]);
}

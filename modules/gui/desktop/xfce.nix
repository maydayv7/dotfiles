{
  config,
  lib,
  util,
  pkgs,
  files,
  ...
}:
with files; let
  inherit (config.gui) desktop wallpaper;
  exists = app: builtins.elem app config.apps.list;
  inherit (lib) mkAfter mkForce mkIf mkMerge;

  # GTK+ Theme
  theme = {
    name = "Arc-Dark";
    package = pkgs.arc-theme;
  };

  # Window Composition
  compositor = config.hardware.cpu.mode != "powersave";
in {
  ## XFCE Desktop Configuration ##
  config = mkIf (desktop == "xfce" || desktop == "xfce-minimal") (mkMerge [
    {
      # Session
      services.xserver = {
        desktopManager.xfce = {
          enable = true;
          enableXfwm = true;
        };

        displayManager = {
          defaultSession = "xfce";
          lightdm.greeters.gtk = {
            clock-format = "%H:%M";
            indicators = [
              "~a11y"
              "~language"
              "~spacer"
              "~clock"
              "~spacer"
              "~host"
              "~spacer"
              "~session"
              "~power"
            ];
          };
        };
      };
    }

    ## Full-Fledged XFCE Desktop Configuration
    (mkIf (desktop == "xfce") {
      # Desktop Integration
      gui =
        {
          fonts.enable = true;
          gtk.enable = true;
        }
        //
        # Desktop Components
        {
          compositor = {
            enable = compositor;
            exclude = [
              "class_g='Xfwm4'"
              "class_g='Xfce4-panel'"
            ];
          };

          launcher = {
            enable = true;
            theme = theme.name;
            terminal = "xfce4-terminal";
          };
        };

      # Essential Utilities
      xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
      services = {
        blueman.enable = true;
        touchegg.enable = true;
        gnome.gnome-keyring.enable = true;
        xserver.displayManager.lightdm.greeters.gtk = {inherit theme;};
      };

      programs = {
        xfconf.enable = true;
        seahorse.enable = true;
        thunar = {
          enable = true;
          plugins = with pkgs.xfce; [
            thunar-archive-plugin
            thunar-dropbox-plugin
            thunar-volman
          ];
        };
      };

      environment = {
        # Theming
        etc."xdg/Kvantum/kvantum.kvconfig".text = mkAfter "theme=KvArcDark";
        variables."GTK_THEME" = theme.name;

        # Utilities
        systemPackages = with pkgs.xfce // pkgs; [
          arc-kde-theme
          galculator
          gnome.file-roller
          mate.atril
          orage
          pavucontrol
          system-config-printer
          transmission-gtk
          xfce4-clipman-plugin
          xfce4-docklike-plugin
          xfce4-eyes-plugin
          xfce4-notes-plugin
          xfce4-panel-profiles
          xfce4-pulseaudio-plugin
          xfce4-sensors-plugin
          xfce4-timer-plugin
          xfce4-weather-plugin
          xfce4-whiskermenu-plugin
          xfce4-windowck-plugin
          xorg.xkill

          (writeShellApplication {
            name = "xfce4-panel-toggle";
            runtimeInputs = [xfce.xfconf];
            text = ''
              for num in {0,1}
              do
                current=$(xfconf-query -c xfce4-panel -p /panels/panel-"$num"/autohide-behavior)
                if [[ current -eq 1 ]]; then next=0; else next=1; fi
                xfconf-query -c xfce4-panel -p /panels/panel-"$num"/autohide-behavior -s $next
              done
            '';
          })
        ];
      };

      # Persisted Files
      user.persist.directories = [
        ".config/Mousepad"
        ".config/Thunar"
        ".config/xfce4"
        ".cache/xfce4"
      ];

      # Color Scheme
      stylix.base16Scheme = colors.arc;

      ## User Configuration
      user.homeConfig = {
        # GTK+ Theming
        stylix.targets.xfce.enable = false;
        gtk = {
          inherit theme;
          gtk3.extraCss = xfce.css;
        };

        # Default Applications
        xdg.mimeApps.defaultApplications = util.build.mime xdg.mime {
          audio = ["org.xfce.Parole.desktop"];
          calendar = ["org.xfce.orage.desktop"];
          directory = ["thunar.desktop"];
          image = ["org.xfce.ristretto.desktop"];
          pdf = ["atril.desktop"];
          text = ["org.xfce.mousepad.desktop"];
          video = ["org.xfce.Parole.desktop"];
        };

        home.file =
          {
            # Touchpad Gestures
            ".config/touchegg/touchegg.conf".text = gestures;
          }
          # Desktop Settings
          // util.map.folder {
            directory = xfce.panel;
            path = ".config/xfce4/panel";
            extension = ".rc";
            apply = text: {inherit text;};
            replace = {
              placeholders = ["@font"];
              values = [config.stylix.fonts.sansSerif.name];
            };
          }
          // util.map.folder {
            directory = xfce.settings;
            path = ".config/xfce4/xfconf/xfce-perchannel-xml";
            extension = ".xml";
            apply = text: {
              inherit text;
              force = true;
            };
            replace = {
              placeholders = [
                "@system"
                "@wallpaper"
                "@theme"
                "@icons"
                "@cursor"
                "@font"
                "@monospace"
                "@compositor"
              ];
              values = [
                path.system
                wallpaper
                theme.name
                "Papirus-Dark"
                config.stylix.cursor.name
                config.stylix.fonts.sansSerif.name
                config.stylix.fonts.monospace.name
                (
                  if compositor
                  then "false"
                  else "true"
                )
              ];
            };
          }
          ## 3rd Party Apps Configuration
          // {
            # Discord Arc Theme
            ".config/BetterDiscord/data/stable/custom.css" =
              mkIf (exists "discord") {text = ''@import url(https://rawcdn.githack.com/orblazer/discord-nordic/f3f6833c70d0b27b1cde986233b7009d61917812/nordic.theme.css);'';};
          };

        # Code Editor
        programs.vscode = mkIf (exists "vscode") {
          extensions = [pkgs.code.vscode-marketplace.alvesvaren.arc-dark];
          userSettings = {
            "workbench.colorTheme" = "Arc Dark Theme";
            "terminal.external.linuxExec" = "xfce4-terminal";
          };
        };
      };
    })

    ## Minimal XFCE Desktop Configuration
    (mkIf (desktop == "xfce-minimal") {
      environment = {
        # Utilities
        systemPackages = [pkgs.epiphany];

        # Excluded Packages
        xfce.excludePackages = with pkgs; [
          tango-icon-theme
          xfce4-icon-theme
          xfwm4-themes
        ];
      };

      # Disabled Services
      services.tumbler.enable = mkForce false;
      services.accounts-daemon.enable = mkForce false;
    })
  ]);
}

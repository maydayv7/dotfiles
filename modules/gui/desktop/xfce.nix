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
  inherit (lib) mkAfter mkForce mkIf mkMerge replaceStrings;

  # GTK+ Theme
  theme = {
    name = "Arc-Dark";
    package = pkgs.arc-theme;
  };
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
      gui = {
        fonts.enable = true;
        gtk.enable = true;
      };

      environment.variables.GTK_THEME = theme.name;
      services = {
        bamf.enable = true;
        blueman.enable = true;
        touchegg.enable = true;
        gnome.gnome-keyring.enable = true;
        xserver.displayManager.lightdm.greeters.gtk = {inherit theme;};
      };

      # Plugins
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
        # QT Theme
        etc."xdg/Kvantum/kvantum.kvconfig".text = mkAfter "theme=KvArcDark";

        # Utilities
        systemPackages = with pkgs.xfce // pkgs; [
          arc-kde-theme
          galculator
          gnome.file-roller
          mate.atril
          orage
          pavucontrol
          plank
          system-config-printer
          transmission-gtk
          ulauncher
          xfce4-clipman-plugin
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
        ];
      };

      # Persisted Files
      user.persist.directories = [
        ".config/Mousepad"
        ".config/plank"
        ".config/Thunar"
        ".config/ulauncher"
        ".config/xfce4"
        ".cache/xfce4"
        ".local/share/ulauncher"
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

            # Plank Dock
            ".config/autostart/Dock.desktop".text = plank.autostart;
            ".local/share/plank/themes/default/dock.theme".text = plank.theme;
            ".config/plank/dock1/launchers" = {
              source = plank.launchers;
              recursive = true;
              force = true;
            };

            # Desktop Settings
            ".config/xfce4/terminal/terminalrc".text = xfce.terminal;
          }
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
              ];
              values = [
                path.system
                wallpaper
                theme.name
                "Papirus-Dark"
                config.stylix.cursor.name
                config.stylix.fonts.sansSerif.name
                config.stylix.fonts.monospace.name
              ];
            };
          }
          ## 3rd Party Apps Configuration
          // (with ulauncher; {
            ## Launcher Settings
            # Themes
            ".config/ulauncher/user-themes" = {
              source = themes;
              recursive = true;
            };

            # Extensions
            ".config/ulauncher/ext_preferences" = {
              source = extensions;
              recursive = true;
              force = true;
            };

            # Scripts
            ".config/ulauncher/scripts.json".text = scripts;

            # Settings
            ".config/ulauncher/extensions.json".text = extension;
            ".config/ulauncher/settings.json".text =
              replaceStrings ["@terminal" "@theme"] ["xfce4-terminal" theme.name] settings;
          });

        # Autostart
        systemd.user.services.ulauncher = {
          Unit.Description = "Start ULauncher";
          Install.WantedBy = ["graphical-session.target"];
          Service = {
            Type = "Simple";
            Restart = "Always";
            RestartSec = 1;
            ExecStart = pkgs.writeShellScript "ulauncher-env-wrapper.sh" ''
              export PATH="''${XDG_BIN_HOME}:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
              export GDK_BACKEND=x11
              exec ${pkgs.ulauncher}/bin/ulauncher --hide-window
            '';
          };
        };

        # Dock Settings
        dconf.settings."net/launchpad/plank/docks/dock1" = {
          current-workspace-only = true;
          icon-size = 60;
          pressure-reveal = true;
          theme = "default";
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

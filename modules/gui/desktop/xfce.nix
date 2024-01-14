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
  inherit (lib) mapAttrs' mkIf mkForce mkMerge nameValuePair replaceStrings;

  # Configuration Folder Creation
  mkFolder = {
    directory,
    path,
    extension ? "",
    replace ? {
      placeholders = {};
      values = {};
    },
  }:
    mapAttrs' (name: value:
      nameValuePair "${path}/${name}${extension}" {
        text = value;
        force = true;
      })
    (util.map.files {
      inherit directory extension;
      apply = file: with replace; replaceStrings placeholders values (builtins.readFile file);
    });

  # GTK+ Theme
  theme = {
    theme = {
      name = "Arc-Dark";
      package = pkgs.arc-theme;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
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
      gui.fonts.enable = true;
      environment.variables.GTK_THEME = theme.theme.name;
      services = {
        bamf.enable = true;
        blueman.enable = true;
        touchegg.enable = true;
        gnome.gnome-keyring.enable = true;
        xserver.displayManager.lightdm.greeters.gtk = theme;
      };

      # Plugins
      programs =
        {
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
        }
        // {gnupg.agent.pinentryFlavor = mkIf config.programs.gnupg.agent.enable "gtk2";};

      # Utilities
      environment.systemPackages = with pkgs.xfce // pkgs; [
        galculator
        mate.atril
        orage
        pavucontrol
        plank
        system-config-printer
        transmission-gtk
        xarchiver
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

      # Persisted Files
      user.persist = {
        directories = [
          ".config/autostart"
          ".config/dconf"
          ".config/Mousepad"
          ".config/plank"
          ".config/Thunar"
          ".config/xfce4"
          ".cache/xfce4"
        ];
      };

      # Color Scheme
      stylix.base16Scheme = colors.arc;

      # QT Theme
      qt = {
        enable = true;
        platformTheme = "gtk2";
        style = "gtk2";
      };

      ## User Configuration
      user.homeConfig = {
        # GTK+ Theming
        stylix.targets.xfce.enable = false;
        gtk =
          {
            enable = true;
            gtk3.extraCss = xfce.css;
          }
          // theme;

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
            # GTK+ Bookmarks
            ".config/gtk-3.0/bookmarks".text = gtk.bookmarks;

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
          // mkFolder {
            directory = xfce.panel;
            path = ".config/xfce4/panel";
            extension = ".rc";
            replace = {
              placeholders = ["@font"];
              values = [config.stylix.fonts.sansSerif.name];
            };
          }
          // mkFolder {
            directory = xfce.settings;
            path = ".config/xfce4/xfconf/xfce-perchannel-xml";
            extension = ".xml";
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
                theme.theme.name
                theme.iconTheme.name
                config.stylix.cursor.name
                config.stylix.fonts.sansSerif.name
                config.stylix.fonts.monospace.name
              ];
            };
          };

        # Dock Settings
        dconf.settings."net/launchpad/plank/docks/dock1" = {
          current-workspace-only = true;
          icon-size = 60;
          pressure-reveal = true;
          theme = "default";
        };

        ## 3rd Party Apps Configuration
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

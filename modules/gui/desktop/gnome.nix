{
  config,
  lib,
  util,
  pkgs,
  files,
  ...
}:
with files; let
  inherit (config.gui) desktop;
  inherit (lib) gvariant mkAfter mkIf mkForce mkMerge;
  exists = app: builtins.elem app config.apps.list;
in {
  ## GNOME Desktop Configuration ##
  config = mkIf (desktop == "gnome" || desktop == "gnome-minimal") (mkMerge [
    {
      # Session
      services = {
        xserver = {
          desktopManager.gnome.enable = true;
          displayManager = {
            gdm.enable = true;
            defaultSession = "gnome";
          };
        };

        # Initial Setup
        gnome.gnome-initial-setup.enable = mkForce false;
      };

      # Excluded Packages
      environment.gnome.excludePackages = with pkgs; [
        gnome.totem
        gnome.gnome-music
      ];

      # Dconf Settings
      programs.dconf.profiles.gdm.databases = [
        {
          settings = {
            "org/gnome/desktop/peripherals/touchpad" = {
              tap-to-click = true;
            };
            "org/gnome/desktop/interface" = {
              cursor-theme = config.stylix.cursor.name;
              cursor-size = gvariant.mkInt32 config.stylix.cursor.size;
            };
          };
        }
      ];
    }

    ## Full-Fledged GNOME Desktop Configuration
    (mkIf (desktop == "gnome") {
      # Desktop Integration
      gui = {
        fonts.enable = true;
        gtk.enable = true;
        wayland.enable = true;
      };

      programs = {
        firefox.enable = true;
        gnupg.agent.pinentryFlavor = mkForce "gnome3";
      };

      services = {
        udev.packages = [pkgs.gnome.gnome-settings-daemon];
        telepathy.enable = true;
        gnome = {
          core-developer-tools.enable = true;
          gnome-keyring.enable = true;
          gnome-remote-desktop.enable = true;
          sushi.enable = true;
        };
      };

      ## User Configuration
      user.homeConfig = {
        # Dconf Keys
        imports = [gnome.dconf];

        # GTK+ Theming
        stylix.targets.gnome.enable = true;
        gtk.theme = {
          name = "adw-gtk3-dark";
          package = pkgs.adw-gtk3;
        };

        # Default Applications
        xdg.mimeApps.defaultApplications = util.build.mime xdg.mime {
          audio = ["org.gnome.Lollypop.desktop"];
          calendar = ["org.gnome.Calendar.desktop"];
          directory = ["org.gnome.Nautilus.desktop"];
          image = ["org.gnome.Loupe.desktop"];
          magnet = ["transmission-gtk.desktop"];
          mail = ["org.gnome.Geary.desktop"];
          markdown = ["org.gnome.gitlab.somas.Apostrophe.desktop"];
          pdf = ["org.gnome.Evince.desktop"];
          text = ["org.gnome.TextEditor.desktop"];
          video = ["io.github.celluloid_player.Celluloid.desktop"];
        };

        home.file =
          {
            # Action Menu
            ".config/guillotine.json".source = gnome.menu;

            # Shell Theme
            ".local/share/themes/custom/gnome-shell/gnome-shell.css".text = gnome.shell;

            # Window Tiling Stylesheet
            ".config/forge/stylesheet/forge/stylesheet.css".text = gnome.tiling;
          }
          //
          ## 3rd Party Apps Configuration
          {
            # Firefox GNOME Theme
            ".mozilla/firefox/default/chrome/userChrome.css".text = ''@import "${pkgs.custom.firefox-gnome-theme}/userChrome.css";'';
            ".mozilla/firefox/default/chrome/userContent.css".text = firefox.gnome;

            # Workaround for NixOS/nixpkgs/47340
            ".mozilla/native-messaging-hosts/org.gnome.chrome_gnome_shell.json".source = "${pkgs.chrome-gnome-shell}/lib/mozilla/native-messaging-hosts/org.gnome.chrome_gnome_shell.json";

            # Discord DNOME Theme
            ".config/BetterDiscord/data/stable/custom.css" =
              mkIf (exists "discord") {text = ''@import "https://raw.githack.com/GeopJr/DNOME/dist/DNOME.css";'';};
          };

        # Code Editor
        programs.vscode = mkIf (exists "vscode") {
          extensions = [pkgs.vscode-extensions.piousdeer.adwaita-theme];
          userSettings = {
            "workbench.colorTheme" = "Adwaita Dark";
            "workbench.productIconTheme" = "adwaita";
            "window.titleBarStyle" = "custom";
            "terminal.external.linuxExec" = "blackbox";
          };
        };
      };

      # Flatpak Apps
      services.flatpak = mkIf config.services.flatpak.enable {
        remotes = [
          {
            name = "gnome-nightly";
            location = "https://nightly.gnome.org/gnome-nightly.flatpakrepo";
          }
        ];

        packages = [
          {
            appId = "com.github.tchx84.Flatseal";
            origin = "flathub";
          }
        ];
      };

      ## Color Scheme
      stylix = {
        base16Scheme = colors.adwaita;
        targets.gnome.enable = false;
      };

      environment = {
        # QT Theme
        etc."xdg/Kvantum/kvantum.kvconfig".text = mkAfter "theme=KvLibadwaitaDark";

        ## Package List
        systemPackages = with pkgs.gnome;
          [
            # GNOME Apps
            gnome-boxes
            gnome-dictionary
            gnome-sound-recorder
            gnome-text-editor
            gnome-tweaks

            # GNOME Games
            gnome-chess
            gnome-mines
            quadrapassel
          ]
          ++ (with pkgs; [
            # GNOME Circle
            apostrophe
            blackbox-terminal
            curtail
            deja-dup
            dialect
            drawing
            fractal
            fragments
            gradience
            gnome-podcasts
            gnome-secrets
            gthumb
            lollypop
            pitivi
            video-trimmer
            wike

            # Utilities
            celluloid
            dconf2nix
            gnuchess
            custom.kvlibadwaita
          ])
          ++ (with pkgs;
            with unstable.gnomeExtensions // gnomeExtensions; [
              # GNOME Shell Extensions
              alttab-mod
              appindicator
              auto-activities
              caffeine
              emoji-copy
              forge
              fullscreen-avoider
              gamemode-indicator-in-system-settings
              guillotine
              lock-keys
              pano
              shortcuts
              status-area-horizontal-spacing
              top-bar-organizer
              transparent-top-bar
              user-avatar-in-quick-settings
              vertical-workspaces
              vitals
              window-gestures
              window-title-is-back
              xlanguagetray
            ]);
      };

      # Persisted Files
      user.persist.directories = [
        ".config/evolution"
        ".config/forge"
        ".config/gnome-boxes"
        ".config/gnome-builder"
        ".config/pitivi"
        ".local/share/clipboard"
        ".local/share/epiphany"
        ".local/share/evolution"
        ".local/share/geary"
        ".local/share/gnome-boxes"
        ".local/share/gnome-builder"
        ".local/share/lollypop"
        ".local/share/nautilus"
        ".local/share/sounds"
        ".local/share/telepathy"
        ".local/share/webkitgtk"
        ".cache/evolution"
        ".cache/fractal"
        ".cache/gnome-builder"
      ];
    })

    ## Minimal GNOME Desktop Configuration
    (mkIf (desktop == "gnome-minimal") {
      # Disable Suspension
      services.xserver = {
        displayManager.gdm.autoSuspend = false;
        desktopManager.gnome = {
          extraGSettingsOverrides = gnome.iso;
          extraGSettingsOverridePackages = [pkgs.gnome.gnome-settings-daemon];
          favoriteAppsOverride = ''
            [org.gnome.shell]
            favorite-apps=[ 'org.gnome.Epiphany.desktop', 'nixos-manual.desktop', 'org.gnome.Console.desktop', 'org.gnome.Nautilus.desktop', 'gparted.desktop' ]
          '';
        };
      };

      # Essential Utilities
      environment.systemPackages = with pkgs.gnome; [
        epiphany
        pkgs.gnome-console
        pkgs.gnome-text-editor
        gnome-system-monitor
        nautilus
      ];

      # Additional Excluded Packages
      xdg.portal.enable = mkForce false;
      qt.enable = mkForce false;

      services.gnome = {
        core-utilities.enable = mkForce false;
        gnome-browser-connector.enable = mkForce false;
        gnome-remote-desktop.enable = mkForce false;
        gnome-user-share.enable = mkForce false;
      };

      environment.gnome.excludePackages = with pkgs.gnome; [
        gnome-backgrounds
        gnome-shell-extensions
        gnome-themes-extra
        pkgs.gnome-tour
        pkgs.gnome-user-docs
        pkgs.hicolor-icon-theme
      ];
    })
  ]);
}

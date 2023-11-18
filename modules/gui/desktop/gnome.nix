{
  config,
  lib,
  util,
  pkgs,
  files,
  ...
}:
with files; let
  inherit (builtins) elem;
  inherit (config.gui) desktop;
  apps = config.environment.systemPackages;
  inherit (lib) mkIf mkForce mkMerge;
in {
  ## GNOME Desktop Configuration ##
  config = mkIf (desktop == "gnome" || desktop == "gnome-minimal") (mkMerge [
    {
      # Session
      services.xserver = {
        desktopManager.gnome.enable = true;
        displayManager = {
          gdm.enable = true;
          defaultSession = "gnome";
        };
      };

      # Excluded Packages
      environment.gnome.excludePackages = with pkgs; [
        gnome.totem
        gnome.gnome-music
      ];
    }

    ## Full-Fledged GNOME Desktop Configuration
    (mkIf (desktop == "gnome") {
      # Desktop Integration
      gui = {
        fonts.enable = true;
        wayland.enable = true;
      };

      programs = {
        dconf.enable = true;
        firefox.enable = true;
        gnupg.agent.pinentryFlavor =
          mkIf config.programs.gnupg.agent.enable "gnome3";
      };

      services = {
        dbus.packages = [pkgs.dconf];
        udev.packages = [pkgs.gnome.gnome-settings-daemon];
        telepathy.enable = true;
        gnome = {
          core-developer-tools.enable = true;
          gnome-browser-connector.enable = true;
          gnome-initial-setup.enable = true;
          gnome-keyring.enable = true;
          gnome-remote-desktop.enable = true;
          sushi.enable = true;
        };
      };

      ## User Configuration
      user.home = {
        # Dconf Keys
        imports = [gnome.dconf];

        # GTK+ Theming
        gtk = {
          enable = true;
          theme = {
            name = "adw-gtk3-dark";
            package = pkgs.adw-gtk3;
          };

          iconTheme = {
            name = "Papirus-Dark";
            package = pkgs.papirus-icon-theme;
          };
        };

        # Default Applications
        xdg.mimeApps.defaultApplications = util.build.mime xdg.mime {
          audio = ["org.gnome.Lollypop.desktop"];
          calendar = ["org.gnome.Calendar.desktop"];
          directory = ["org.gnome.Nautilus.desktop"];
          image = ["org.gnome.eog.desktop"];
          magnet = ["transmission-gtk.desktop"];
          mail = ["org.gnome.Geary.desktop"];
          markdown = ["org.gnome.gitlab.somas.Apostrophe.desktop"];
          pdf = ["org.gnome.Evince.desktop"];
          text = ["org.gnome.TextEditor.desktop"];
          video = ["io.github.celluloid_player.Celluloid.desktop"];
        };

        home.file = {
          # Initial Setup
          ".config/gnome-initial-setup-done".text = "yes";

          # GTK+ Bookmarks
          ".config/gtk-3.0/bookmarks".text = gtk.bookmarks;

          # Action Menu
          ".config/guillotine.json".source = gnome.menu;

          # Window Tiling Stylesheet
          ".config/forge/stylesheet/forge/stylesheet.css".source = gnome.tiling;

          # Prevent Suspension on lid close
          ".config/autostart/ignore-lid-switch-tweak.desktop".text = ''
            [Desktop Entry]
            Type=Application
            Name=ignore-lid-switch-tweak
            Exec=${pkgs.gnome.gnome-tweaks}/libexec/gnome-tweak-tool-lid-inhibitor
          '';

          # Discord DNOME Theme
          ".config/BetterDiscord/data/stable/custom.css" =
            mkIf (elem pkgs.discord apps)
            {text = ''@import "https://raw.githack.com/GeopJr/DNOME/dist/DNOME.css";'';};

          # Firefox GNOME Theme
          ".mozilla/firefox/default/chrome/userChrome.css".text = ''@import "${pkgs.custom.firefox-gnome-theme}/userChrome.css";'';
          ".mozilla/firefox/default/chrome/userContent.css".text = firefox.theme;
        };

        ## 3rd Party Apps Configuration
        # Code Editor
        programs.vscode = mkIf (elem pkgs.vscode apps) {
          extensions = [pkgs.vscode-extensions.piousdeer.adwaita-theme];
          userSettings = {
            "workbench.preferredDarkColorTheme" = "Adwaita Dark";
            "workbench.preferredLightColorTheme" = "Adwaita Light";
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
        variables."QT_STYLE_OVERRIDE" = mkForce "kvantum";
        etc."xdg/Kvantum/kvantum.kvconfig".text = ''
          [General]
          theme=KvLibadwaitaDark
        '';

        ## Package List
        systemPackages = with pkgs;
          [libsForQt5.qtstyleplugin-kvantum custom.kvlibadwaita]
          ++ (with pkgs.gnome; [
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
          ])
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
            gimp
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
          ])
          ++ (with pkgs.gnomeExtensions; [
            # GNOME Shell Extensions
            alphabetical-app-grid
            appindicator
            caffeine
            coverflow-alt-tab
            emoji-copy
            forge
            gesture-improvements
            gnome-40-ui-improvements
            guillotine
            just-perfection
            lock-keys
            lock-screen-message
            pano
            quick-settings-tweaker
            rounded-window-corners
            shortcuts
            space-bar
            status-area-horizontal-spacing
            timepp
            transparent-top-bar-adjustable-transparency
            top-bar-organizer
            user-avatar-in-quick-settings
            vitals
            weather-oclock
          ]);
      };

      # Persisted Files
      user.persist.directories = [
        ".config/dconf"
        ".config/forge"
        ".config/gnome-boxes"
        ".config/gnome-builder"
        ".config/GIMP"
        ".config/gtk-3.0"
        ".config/gtk-4.0"
        ".config/pitivi"
        ".local/share/clipboard"
        ".local/share/epiphany"
        ".local/share/evolution"
        ".local/share/geary"
        ".local/share/gnome-boxes"
        ".local/share/gnome-builder"
        ".local/share/lollypop"
        ".local/share/nautilus"
        ".local/share/telepathy"
        ".local/share/webkitgtk"
        ".cache/fractal"
        ".cache/gnome-builder"
        ".cache/timepp_gnome_shell_extension"
      ];
    })

    ## Minimal GNOME Desktop Configuration
    (mkIf (desktop == "gnome-minimal") {
      # Disable Suspension
      services.xserver = {
        displayManager.gdm.autoSuspend = false;
        desktopManager.gnome = {
          favoriteAppsOverride = ''
            [org.gnome.shell]
            favorite-apps=[ 'org.gnome.Epiphany.desktop', 'nixos-manual.desktop', 'org.gnome.Console.desktop', 'org.gnome.Nautilus.desktop', 'gparted.desktop' ]
          '';

          extraGSettingsOverrides = gnome.iso;
          extraGSettingsOverridePackages = [pkgs.gnome.gnome-settings-daemon];
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
      services.gnome.core-utilities.enable = mkForce false;
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

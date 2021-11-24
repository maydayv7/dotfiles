{ config, files, username, lib, inputs, pkgs, ... }:
let
  desktop = config.gui.desktop;
  apps = config.apps.list;
in rec
{
  ## GNOME Desktop Configuration ##
  config = lib.mkIf (desktop == "gnome" || desktop == "gnome-minimal")
  (lib.mkMerge
  [
    {
      gui.enableXorg = true;
      services.xserver =
      {   
        # Touchpad
        libinput.enable = true;
        libinput.touchpad.tapping = true;
        libinput.touchpad.tappingDragLock = true;

        # GNOME
        desktopManager.gnome.enable = true;
        displayManager =
        {
          gdm.enable = true;
          defaultSession = "gnome-xorg";
        };
      };

      # Excluded GNOME Packages
      environment.gnome.excludePackages = with pkgs;
      [
        gnome.totem
        gnome.gnome-music
      ];
    }

    # Full-Fledged GNOME Desktop Configuration
    (lib.mkIf (desktop == "gnome")
    {
      # Desktop Integration
      programs.dconf.enable = true;
      programs.gnupg.agent.pinentryFlavor = "gnome3";
      services =
      {
        dbus.packages = [ pkgs.gnome.dconf ];
        udev.packages = [ pkgs.gnome.gnome-settings-daemon ];
        touchegg.enable = true;
        gnome =
        {
          chrome-gnome-shell.enable = true;
          experimental-features.realtime-scheduling = true;
          gnome-initial-setup.enable = true;
          gnome-keyring.enable = true;
          gnome-remote-desktop.enable = true;
          sushi.enable = true;
        };
      };

      # User Configuration
      home-manager.users."${username}" =
      {
        imports = [ files.dconf ];

        # GTK+
        gtk =
        {
          enable = true;
          theme =
          {
            name = "Adwaita-dark";
            package = pkgs.gnome.gnome-themes-extra;
          };
          iconTheme =
          {
            name = "Papirus-Dark";
            package = pkgs.papirus-icon-theme;
          };
        };

        home.file =
        {
          # GTK+ Bookmarks
          ".config/gtk-3.0/bookmarks".text = files.gnome.bookmarks;

          # X11 Gestures
          ".config/touchegg/touchegg.conf".text = files.touchegg;

          # Custome GNOME Shell Theme
          ".themes/Adwaita/gnome-shell/gnome-shell.css".text = files.gnome.theme;

          # gEdit Color Scheme
          ".local/share/gtksourceview-4/styles/tango-dark.xml".text = files.gedit.theme;
          ".local/share/gtksourceview-4/language-specs/nix.lang".text = files.gedit.syntax;

          # Discord DNOME Theme
          ".config/BetterDiscord/data/stable/custom.css" = lib.mkIf (builtins.elem "discord" apps) { text = files.discord.theme; };

          # Firefox GNOME Theme
          ".mozilla/firefox/v7/chrome/userChrome.css" = lib.mkIf (builtins.elem "firefox" apps) { text = ''@import "${inputs.firefox}/userChrome.css";''; };
        };
      };

      environment.systemPackages = with pkgs;
      [
        # GNOME Apps
        gnome.dconf-editor
        gnome.gnome-boxes
        gnome.gnome-dictionary
        gnome.gnome-notes
        gnome.gnome-sound-recorder
        gnome.gnome-tweaks
        gnome.polari

        # GNOME Games
        gnome.gnome-chess
        gnome.gnome-mines
        gnome.gnome-sudoku
        gnome.quadrapassel

        # GNOME Circle
        apostrophe
        drawing
        deja-dup
        fractal
        fragments
        giara
        gimp
        gnome-podcasts
        gnome-passwordsafe
        gthumb
        kooha
        markets
        shortwave
        wike

        # GNOME Shell Extensions
        gnomeExtensions.appindicator
        gnomeExtensions.caffeine
        gnomeExtensions.clipboard-indicator
        gnomeExtensions.color-picker
        gnomeExtensions.compiz-windows-effect
        gnomeExtensions.compiz-alike-magic-lamp-effect
        gnomeExtensions.custom-hot-corners-extended
        gnomeExtensions.dash-to-panel
        # gnomeExtensions.fly-pie
        gnomeExtensions.just-perfection
        gnomeExtensions.lock-keys
        # gnomeExtensions.screenshot-locations
        gnomeExtensions.sound-output-device-chooser
        gnomeExtensions.vitals
        gnomeExtensions.x11-gestures

        # Utilities
        dconf2nix
        gnuchess
      ];
    })

    # Minimal GNOME Desktop Configuration
    (lib.mkIf (desktop == "gnome-minimal")
    {
      # Disable Suspension
      services.xserver.displayManager.gdm.autoSuspend = false;

      # Additional Excluded GNOME Packages
      environment.gnome.excludePackages = with pkgs;
      [
        gnome.baobab
        gnome.geary
        gnome.gnome-backgrounds
        gnome.gnome-calendar
        gnome.gnome-characters
        gnome-connections
        gnome.gnome-contacts
        gnome.gnome-logs
        gnome.gnome-maps
        gnome.gnome-weather
        gnome-photos
        gnome.simple-scan
        gnome.simple-scan
        gnome-tour
        gnome-user-docs
        gnome.yelp
        hicolor-icon-theme
      ];
    })
  ]);
}

{ config, lib, util, inputs, pkgs, files, ... }:
let
  inherit (util) map;
  inherit (builtins) elem;
  inherit (lib) mkIf mkForce mkMerge;
  desktop = config.gui.desktop;
  apps = config.environment.systemPackages;
  username = config.user.settings.name;
in rec
{
  ## GNOME Desktop Configuration ##
  config = mkIf (desktop == "gnome" || desktop == "gnome-minimal")
  (mkMerge
  [
    {
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
    (mkIf (desktop == "gnome")
    {
      # Desktop Integration
      programs =
      {
        dconf.enable = true;
        xwayland.enable = true;
        gnupg.agent.pinentryFlavor = "gnome3";
      };

      services =
      {
        dbus.packages = [ pkgs.gnome.dconf ];
        udev.packages = [ pkgs.gnome.gnome-settings-daemon ];
        touchegg.enable = true;
        gnome =
        {
          chrome-gnome-shell.enable = true;
          core-developer-tools.enable = true;
          experimental-features.realtime-scheduling = true;
          gnome-initial-setup.enable = true;
          gnome-keyring.enable = true;
          gnome-remote-desktop.enable = true;
          sushi.enable = true;
        };
      };

      # User Configuration
      user.home =
      {
        # Dconf Keys
        imports = [ files.gnome.dconf ];

        # GTK+ Theming
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

        # Display Settings
        xresources.extraConfig = files.xorg;

        # Default Applications
        xdg.mimeApps.defaultApplications = map.mime
        {
          audio = [ "org.gnome.Lollypop.desktop" ];
          browser = [ "google-chrome.desktop" ];
          calendar = [ "org.gnome.Calendar.desktop" ];
          directory = [ "org.gnome.Nautilus.desktop" ];
          image = [ "org.gnome.eog.desktop" ];
          magnet = [ "transmission-gtk.desktop" ];
          mail = [ "org.gnome.Geary.desktop" ];
          markdown = [ "org.gnome.gitlab.somas.Apostrophe.desktop" ];
          pdf = [ "org.gnome.Evince.desktop" ];
          text = [ "org.gnome.gedit.desktop" ];
          video = [ "io.github.celluloid_player.Celluloid.desktop" ];
        };

        home.file =
        {
          # GTK+ Bookmarks
          ".config/gtk-3.0/bookmarks".text = files.gnome.bookmarks;

          # X11 Gestures
          ".config/touchegg/touchegg.conf".text = files.gestures;

          # Online Accounts
          ".config/goa-1.0/accounts.conf".text = files.gnome.accounts;

          # Custome GNOME Shell Theme
          ".themes/Adwaita/gnome-shell/gnome-shell.css".text = files.gnome.shell;

          # gEdit Color Scheme
          ".local/share/gtksourceview-4/styles/tango-dark.xml".text = files.gnome.theme;
          ".local/share/gtksourceview-4/language-specs/nix.lang".text = files.gnome.syntax;

          # Discord DNOME Theme
          ".config/BetterDiscord/data/stable/custom.css" = lib.mkIf (elem pkgs.discord apps) { text = files.discord.theme; };

          # Firefox GNOME Theme
          ".mozilla/firefox/${username}/chrome/userChrome.css" = lib.mkIf (elem pkgs.firefox apps) { text = ''@import "${inputs.firefox}/userChrome.css";''; };
        };
      };

      environment.systemPackages = with pkgs;
      [
        # GNOME Apps
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
        unstable.gnomeExtensions.pop-shell
        gnomeExtensions.screenshot-locations
        gnomeExtensions.sound-output-device-chooser
        gnomeExtensions.vitals
        gnomeExtensions.x11-gestures

        # Utilities
        dconf2nix
        google-chrome
        gnuchess
        transmission-gtk
      ];
    })

    # Minimal GNOME Desktop Configuration
    (mkIf (desktop == "gnome-minimal")
    {
      # Disable Suspension
      services.xserver.displayManager.gdm.autoSuspend = false;

      # Essential Utilities
      environment.systemPackages = with pkgs.gnome;
      [
        epiphany
        gedit
        gnome-system-monitor
        gnome-terminal
        nautilus
      ];

      # Additional Excluded Packages
      xdg.portal.enable = mkForce false;
      qt5.enable = mkForce false;
      services.gnome.core-utilities.enable = mkForce false;
      environment.gnome.excludePackages = with pkgs.gnome;
      [
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

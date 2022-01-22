{ config, lib, inputs, pkgs, files, ... }:
with files.gnome;
let
  inherit (builtins) elem;
  inherit (lib) mkIf mkForce mkMerge util;
  inherit (config.gui) desktop;
  inherit (config) programs user;
  apps = config.environment.systemPackages;
in rec {
  ## GNOME Desktop Configuration ##
  config = mkIf (desktop == "gnome" || desktop == "gnome-minimal") (mkMerge [
    {
      services.xserver = {
        # Touchpad
        libinput.enable = true;
        libinput.touchpad.tapping = true;
        libinput.touchpad.tappingDragLock = true;

        # GNOME
        desktopManager.gnome.enable = true;
        displayManager = {
          gdm.enable = true;
          defaultSession = "gnome-xorg";
        };
      };

      # Excluded GNOME Packages
      environment.gnome.excludePackages = with pkgs; [
        gnome.totem
        gnome.gnome-music
      ];
    }

    # Full-Fledged GNOME Desktop Configuration
    (mkIf (desktop == "gnome") {
      # Desktop Integration
      gui.fonts.enable = true;
      nixpkgs.config.firefox.enableGnomeExtensions =
        mkIf (elem pkgs.firefox apps) true;
      programs = {
        dconf.enable = true;
        xwayland.enable = true;
        gnupg.agent.pinentryFlavor = mkIf programs.gnupg.agent.enable "gnome3";
      };

      services = {
        dbus.packages = [ pkgs.gnome.dconf ];
        udev.packages = [ pkgs.gnome.gnome-settings-daemon ];
        touchegg.enable = true;
        gnome = {
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
      user.home = {
        # Dconf Keys
        imports = [ dconf ];

        # GTK+ Theming
        gtk = {
          enable = true;

          theme = {
            name = "Adwaita-dark";
            package = pkgs.gnome.gnome-themes-extra;
          };

          iconTheme = {
            name = "Papirus-Dark";
            package = pkgs.papirus-icon-theme;
          };
        };

        # Display Settings
        xresources.extraConfig = files.xorg;

        # Default Applications
        xdg.mimeApps.defaultApplications =
          util.xdg.mime (import files.xdg.mime) {
            audio = [ "org.gnome.Lollypop.desktop" ];
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

        home.file = {
          # Initial Setup
          ".config/gnome-initial-setup-done".text = "yes";

          # Online Accounts
          ".config/goa-1.0/accounts.conf".text = accounts;

          # GTK+ Bookmarks
          ".config/gtk-3.0/bookmarks".text = bookmarks;

          # X11 Gestures
          ".config/touchegg/touchegg.conf".text = files.gestures;

          # Custome GNOME Shell Theme
          ".themes/Adwaita/gnome-shell/gnome-shell.css".text = shell;

          # gEdit Color Scheme
          ".local/share/gtksourceview-4/styles/tango-dark.xml".text = theme;
          ".local/share/gtksourceview-4/language-specs/nix.lang".text = syntax;

          # Discord DNOME Theme
          ".config/BetterDiscord/data/stable/custom.css" =
            mkIf (elem pkgs.discord apps) { text = files.discord.theme; };

          # Firefox GNOME Theme
          ".mozilla/firefox/default/chrome/userChrome.css".text =
            mkIf (elem pkgs.firefox apps)
            ''@import "${inputs.firefox-theme}/userChrome.css";'';
          ".mozilla/native-messaging-hosts/org.gnome.chrome_gnome_shell.json".source =
            mkIf (elem pkgs.firefox apps)
            "${pkgs.chrome-gnome-shell}/lib/mozilla/native-messaging-hosts/org.gnome.chrome_gnome_shell.json";
        };
      };

      environment.systemPackages = with pkgs.gnome;
        [
          # GNOME Apps
          gnome-boxes
          gnome-dictionary
          gnome-notes
          gnome-sound-recorder
          gnome-tweaks
          polari

          # GNOME Games
          gnome-chess
          gnome-mines
          quadrapassel
        ] ++ (with pkgs; [
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
          lollypop
          pitivi
          wike

          # Utilities
          celluloid
          dconf2nix
          gnuchess
        ]) ++ (with pkgs;
          with gnomeExtensions;
          with unstable.gnomeExtensions; [
            # GNOME Shell Extensions
            add-username-to-top-panel
            appindicator
            burn-my-windows
            caffeine
            clipboard-indicator
            color-picker
            compiz-windows-effect
            compiz-alike-magic-lamp-effect
            custom-hot-corners-extended
            dash-to-panel
            desktop-cube
            custom.fly-pie
            gtile
            just-perfection
            lock-keys
            screenshot-locations
            sound-output-device-chooser
            timepp
            custom.top-bar-organizer
            vitals
            x11-gestures
          ]);
    })

    # Minimal GNOME Desktop Configuration
    (mkIf (desktop == "gnome-minimal") {
      # Disable Suspension
      services.xserver.displayManager.gdm.autoSuspend = false;

      # Essential Utilities
      environment.systemPackages = with pkgs.gnome; [
        epiphany
        gedit
        gnome-system-monitor
        pkgs.kgx
        nautilus
      ];

      # Additional Excluded Packages
      xdg.portal.enable = mkForce false;
      qt5.enable = mkForce false;
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

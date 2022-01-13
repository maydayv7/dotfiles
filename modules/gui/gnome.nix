{ config, lib, inputs, pkgs, files, ... }:
let
  inherit (builtins) elem;
  inherit (lib) mkIf mkForce mkMerge util;
  apps = config.environment.systemPackages;
  desktop = config.gui.desktop;
  programs = config.programs;
  username = config.user.name;
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
      nixpkgs.config.firefox.enableGnomeExtensions = true;
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
        imports = [ files.gnome.dconf ];

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
            browser = [ "firefox.desktop" ];
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
          # GTK+ Bookmarks
          ".config/gtk-3.0/bookmarks".text = files.gnome.bookmarks;

          # X11 Gestures
          ".config/touchegg/touchegg.conf".text = files.gestures;

          # Online Accounts
          ".config/goa-1.0/accounts.conf".text = files.gnome.accounts;

          # Custome GNOME Shell Theme
          ".themes/Adwaita/gnome-shell/gnome-shell.css".text =
            files.gnome.shell;

          # gEdit Color Scheme
          ".local/share/gtksourceview-4/styles/tango-dark.xml".text =
            files.gnome.theme;
          ".local/share/gtksourceview-4/language-specs/nix.lang".text =
            files.gnome.syntax;

          # Discord DNOME Theme
          ".config/BetterDiscord/data/stable/custom.css" =
            mkIf (elem pkgs.discord apps) { text = files.discord.theme; };

          # Firefox GNOME Theme
          ".mozilla/firefox/${username}/chrome/userChrome.css".text =
            ''@import "${inputs.firefox-theme}/userChrome.css";'';
          ".mozilla/native-messaging-hosts/org.gnome.chrome_gnome_shell.json".source =
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
          gnome-sudoku
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
          markets
          pitivi
          shortwave
          wike

          # Utilities
          celluloid
          dconf2nix
          firefox
          gnuchess
          transmission-gtk
        ]) ++ (with pkgs;
          with gnomeExtensions;
          with unstable.gnomeExtensions; [
            # GNOME Shell Extensions
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
            #fly-pie
            gtile
            just-perfection
            lock-keys
            screenshot-locations
            sound-output-device-chooser
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

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
  exists = app: builtins.elem app config.apps.list;
  inherit (lib) mkForce mkIf mkMerge;
in {
  ## Pantheon Desktop Configuration ##
  config = mkIf (desktop == "pantheon" || desktop == "pantheon-minimal") (mkMerge [
    {
      # Session
      services.xserver.desktopManager.pantheon.enable = true;
    }

    ## Full-Fledged Pantheon Desktop Configuration
    (mkIf (desktop == "pantheon") {
      warnings = ["Flatpak app support is enabled by default while using Pantheon Desktop"];

      # Desktop Integration
      gui = {
        fonts.enable = true;
        gtk.enable = true;
        icons.name = "ePapirus-Dark";
        theme = {
          name = "io.elementary.stylesheet.blueberry";
          package = pkgs.pantheon.elementary-gtk-theme;
        };

        cursors = {
          name = "elementary";
          package = pkgs.pantheon.elementary-icon-theme;
        };

        launcher = {
          enable = true;
          theme = "elementary";
          terminal = "io.elementary.terminal";
        };
      };

      # Essential Utilities
      services.pantheon.apps.enable = true;
      programs = {
        firefox.enable = true;
        pantheon-tweaks.enable = true;
      };

      # Panel Indicators
      services.xserver.desktopManager.pantheon.extraWingpanelIndicators = with pkgs; [
        monitor
        wingpanel-indicator-ayatana
      ];

      environment = {
        # QT Theme
        variables = {
          "QT_QPA_PLATFORMTHEME" = "gtk3";
          "QT_STYLE_OVERRIDE" = mkForce "";
        };

        # Panel Indicator Compatibility
        pathsToLink = ["/libexec"];

        # Apps
        systemPackages = with pkgs.pantheon // pkgs; [
          appeditor
          gthumb
          torrential
        ];
      };

      # Persisted Files
      user.persist.directories = [
        ".config/evolution"
        ".config/plank"
        ".config/torrential"
        ".local/share/contractor"
        ".local/share/evolution"
        ".local/share/io.elementary.code"
        ".local/share/io.elementary.photos"
        ".cache/evolution"
        ".cache/io.elementary.appcenter"
      ];

      # Color Scheme
      stylix.base16Scheme = colors.elementary;

      ## User Configuration
      user.homeConfig = {
        imports = [pantheon.dconf];

        # Default Applications
        xdg.mimeApps.defaultApplications = util.build.mime xdg.mime {
          audio = ["io.elementary.files.desktop"];
          calendar = ["io.elementary.calendar.desktop"];
          directory = ["io.elementary.files.desktop"];
          image = ["io.elementary.photos.desktop"];
          pdf = ["org.gnome.Evince.desktop"];
          text = ["io.elementary.code.desktop"];
          video = ["io.elementary.videos.desktop"];
        };

        # App Indicator Autostart
        systemd.user.services.indicator-application-gtk3 = {
          Unit.Description = "Application Indicator";
          Install.wantedBy = ["graphical-session.target"];
          Service = {
            Type = "Simple";
            ExecStart = "${pkgs.indicator-application-gtk3}/libexec/indicator-application/indicator-application-service";
          };
        };

        home = {
          file = {
            # Plank Dock
            ".config/autostart/Dock.desktop".text = plank.autostart;
            ".local/share/plank/themes/default/dock.theme".text = plank.theme;
            ".config/plank/dock1/launchers" = {
              source = plank.launchers;
              recursive = true;
              force = true;
            };

            # Firefox Elementary Theme
            ".mozilla/firefox/default/chrome/userChrome.css".source = "${pkgs.custom.firefox-elementary-theme}/Windows/userChrome.css";
            ".mozilla/firefox/default/chrome/userContent.css".source = "${pkgs.custom.firefox-elementary-theme}/userContent.css";
            ".mozilla/firefox/default/chrome/base.css".source = "${pkgs.custom.firefox-elementary-theme}/base.css";

            # Panel Indicators
            ".config/autostart/ibus-daemon.desktop".text = ''
              [Desktop Entry]
              Name=IBus Daemon
              Type=Application
              Exec=${pkgs.ibus}/bin/ibus-daemon --daemonize --desktop=pantheon --replace --xim
              Categories=
              Terminal=false
              NoDisplay=true
              StartupNotify=false
            '';

            ".config/autostart/monitor-background.desktop".text = ''
              [Desktop Entry]
              Name=Monitor Indicators
              Type=Application
              Exec=/run/current-system/sw/bin/com.github.stsdc.monitor --start-in-background
              Icon=com.github.stsdc.monitor
              Categories=
              Terminal=false
              NoDisplay=true
              StartupNotify=false
            '';
          };
        };

        ## 3rd Party Apps Configuration
        # Code Editor
        programs.vscode = mkIf (exists "vscode") {
          extensions = [pkgs.code.vscode-marketplace.sixpounder.elementary-theme];
          userSettings = {
            "workbench.colorTheme" = "Elementary Dark";
            "terminal.external.linuxExec" = "io.elementary.terminal";
          };
        };
      };

      # Flatpak Apps
      apps.list = ["flatpak"];
      services.flatpak = {
        remotes = [
          {
            name = "appcenter";
            location = "https://flatpak.elementary.io/repo.flatpakrepo";
          }
        ];

        packages = [
          {
            appId = "com.github.hezral.clips";
            origin = "appcenter";
          }
        ];
      };
    })

    ## Minimal Pantheon Desktop Configuration
    (mkIf (desktop == "pantheon-minimal") {
      # Disabled Services
      services.fwupd.enable = mkForce false;
      services.power-profiles-daemon.enable = mkForce false;
      services.tumbler.enable = mkForce false;
      services.geoclue2.enable = mkForce false;

      # Excluded Packages
      environment.pantheon.excludePackages = with pkgs.pantheon; [
        elementary-camera
        elementary-music
        elementary-photos
        elementary-videos
      ];
    })
  ]);
}

{
  config,
  lib,
  util,
  pkgs,
  files,
  ...
}:
let
  inherit (config.gui) desktop;
  exists = app: builtins.elem app config.apps.list;
  inherit (lib)
    getExe
    mkIf
    mkMerge
    ;
in
{
  ## Pantheon Desktop Configuration ##
  config = mkIf (desktop == "pantheon") (mkMerge [
    {
      # Session
      services.xserver = {
        enable = true;
        desktopManager.pantheon.enable = true;
      };

      # Desktop Integration
      gui = {
        gtk = {
          enable = true;
          theme = {
            name = "io.elementary.stylesheet.blueberry";
            package = pkgs.pantheon.elementary-gtk-theme;
          };
        };

        qt = {
          enable = true;
          style = "gtk";
        };

        cursors = {
          name = "elementary";
          package = pkgs.pantheon.elementary-icon-theme;
          size = 32;
        };
      };

      # Color Scheme
      stylix.base16Scheme = files.colors.elementary;

      # Essential Utilities
      apps.list = [ "firefox" ];
      services.pantheon.apps.enable = true;

      # Panel Indicators
      environment.pathsToLink = [ "/libexec" ];
      services.xserver.desktopManager.pantheon.extraWingpanelIndicators = with pkgs; [
        # monitor # ! # https://github.com/NixOS/nixpkgs/issues/408811
        wingpanel-indicator-ayatana
      ];

      # Apps
      environment.systemPackages = with pkgs.pantheon // pkgs; [
        appeditor
        pantheon-tweaks
        torrential
      ];

      # Persisted Files
      user.persist.directories = [
        ".config/evolution"
        ".config/plank"
        ".config/torrential"
        ".local/share/contractor"
        ".local/share/evolution"
        ".local/share/Emote"
        ".local/share/io.elementary.code"
        ".local/share/io.elementary.photos"
        ".cache/evolution"
        ".cache/io.elementary.appcenter"
      ];

      user.homeConfig = {
        ## Desktop Settings
        imports = [ ./settings.nix ];
        stylix.targets.gnome.enable = false;

        # Default Applications
        xdg.mimeApps.defaultApplications = util.build.mime {
          audio = [ "io.elementary.files.desktop" ];
          calendar = [ "io.elementary.calendar.desktop" ];
          directory = [ "io.elementary.files.desktop" ];
          image = [ "io.elementary.photos.desktop" ];
          pdf = [ "org.gnome.Evince.desktop" ];
          text = [ "io.elementary.code.desktop" ];
          video = [ "io.elementary.videos.desktop" ];
        };

        systemd.user.services = {
          # App Indicator
          indicator-application-gtk3 = {
            Unit.Description = "Application Indicator";
            Install.wantedBy = [ "graphical-session.target" ];
            Service = {
              Type = "Simple";
              ExecStart = "${pkgs.indicator-application-gtk3}/libexec/indicator-application/indicator-application-service";
            };
          };

          # Emoji Picker
          emote = {
            Unit.Description = "Emote Emoji Picker";
            Install.WantedBy = [ "graphical-session.target" ];
            Service = {
              ExecStart = "${getExe pkgs.emote}";
              Restart = "on-failure";
            };
          };
        };

        home = {
          file = {
            # Firefox Elementary Theme
            ".mozilla/firefox/default/chrome/userChrome.css".source =
              "${pkgs.custom.firefox-elementary}/Windows/userChrome.css";
            ".mozilla/firefox/default/chrome/userContent.css".source =
              "${pkgs.custom.firefox-elementary}/userContent.css";
            ".mozilla/firefox/default/chrome/base.css".source = "${pkgs.custom.firefox-elementary}/base.css";

            # Panel Indicators
            ".config/autostart/ibus-daemon.desktop".text = ''
              [Desktop Entry]
              Name=IBus Daemon
              Type=Application
              Exec=ibus-daemon --daemonize --desktop=pantheon --replace --xim
              Categories=
              Terminal=false
              NoDisplay=true
              StartupNotify=false
            '';

            ".config/autostart/monitor-background.desktop".text = ''
              [Desktop Entry]
              Name=Monitor Indicators
              Type=Application
              Exec=com.github.stsdc.monitor --start-in-background
              Icon=com.github.stsdc.monitor
              Categories=
              Terminal=false
              NoDisplay=true
              StartupNotify=false
            '';
          };
        };
      };
    }

    ## 3rd Party Apps Configuration
    {
      # Code Editor
      user.homeConfig.programs.vscode.profiles.default = mkIf (exists "vscode") {
        extensions = [ pkgs.code.vscode-marketplace.sixpounder.elementary-theme ];
        userSettings = {
          "workbench.colorTheme" = "Elementary Dark";
          "terminal.external.linuxExec" = "io.elementary.terminal";
        };
      };

      # Flatpak
      warnings = [ "Flatpak app support is enabled by default while using Pantheon Desktop" ];
      apps.list = [ "flatpak" ];
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
    }
  ]);
}

{
  util ? null,
  files ? null,
  ...
}: {
  nixos = {pkgs, ...}: {
    # Session
    services = {
      xserver.enable = true;
      desktopManager.pantheon.enable = true;
    };

    # Desktop Integration
    gui = {
      gtk.theme = {
        name = "io.elementary.stylesheet.blueberry";
        package = pkgs.pantheon.elementary-gtk-theme;
      };

      qt.style = "gtk";

      cursors = {
        name = "elementary";
        package = pkgs.pantheon.elementary-icon-theme;
        size = 32;
      };
    };

    # Color Scheme
    stylix.base16Scheme = files.colors.elementary;

    # Essential Utilities
    services.pantheon.apps.enable = true;

    # Panel Indicators
    environment.pathsToLink = ["/libexec"];
    services.desktopManager.pantheon.extraWingpanelIndicators = with pkgs; [
      monitor
      wingpanel-indicator-ayatana
    ];

    # Apps
    environment.systemPackages = with pkgs.pantheon // pkgs; [
      appeditor
      pantheon-tweaks
    ];

    # Flatpak
    warnings = ["Flatpak support is enabled by default for Pantheon Desktop"];
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
  };

  home = {
    config,
    lib,
    pkgs,
    ...
  }: {
    ## Desktop Settings
    imports = [(import ./settings.nix {inherit util files;})];
    stylix.targets.gnome.enable = false;

    # Default Applications
    xdg.mimeApps.defaultApplications = util.build.mime {
      audio = ["io.elementary.files.desktop"];
      calendar = ["io.elementary.calendar.desktop"];
      directory = ["io.elementary.files.desktop"];
      image = ["io.elementary.photos.desktop"];
      pdf = ["org.gnome.Evince.desktop"];
      text = ["io.elementary.code.desktop"];
      video = ["io.elementary.videos.desktop"];
    };

    systemd.user.services = {
      # App Indicator
      indicator-application-gtk3 = {
        Unit.Description = "Application Indicator";
        Install.wantedBy = ["graphical-session.target"];
        Service = {
          Type = "Simple";
          ExecStart = "${pkgs.indicator-application-gtk3}/libexec/indicator-application/indicator-application-service";
        };
      };

      # Emoji Picker
      emote = {
        Unit.Description = "Emote Emoji Picker";
        Install.WantedBy = ["graphical-session.target"];
        Service = {
          ExecStart = "${lib.getExe pkgs.emote}";
          Restart = "on-failure";
        };
      };
    };

    home = {
      # Persisted Files
      persist.directories = [
        ".config/evolution"
        ".local/share/contractor"
        ".local/share/evolution"
        ".local/share/Emote"
        ".local/share/io.elementary.code"
        ".local/share/io.elementary.photos"
        ".cache/evolution"
        ".cache/io.elementary.appcenter"
      ];

      file = {
        # Firefox Elementary Theme
        ".mozilla/firefox/default/chrome/userChrome.css".source = "${pkgs.custom.firefox-elementary}/Windows/userChrome.css";
        ".mozilla/firefox/default/chrome/userContent.css".source = "${pkgs.custom.firefox-elementary}/userContent.css";
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

    # Code Editor
    programs.vscode.profiles.default = lib.mkIf config.programs.vscode.enable {
      extensions = [pkgs.vscode-marketplace.sixpounder.elementary-theme];
      userSettings = {
        "workbench.colorTheme" = "Elementary Dark";
        "terminal.external.linuxExec" = "io.elementary.terminal";
      };
    };
  };
}

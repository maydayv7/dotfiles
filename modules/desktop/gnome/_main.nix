{
  util ? null,
  files ? null,
  ...
}: {
  nixos = {pkgs, ...}: {
    # Desktop Integration
    gui = {
      gtk.theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };

      qt = {
        style = "kvantum";
        theme = {
          name = "KvLibadwaitaDark";
          package = pkgs.custom.kvlibadwaita;
        };
      };
    };

    # Color Scheme
    stylix = {
      base16Scheme = files.colors.adwaita;
      targets.gnome.enable = false;
    };

    # Essential Utilities
    services = {
      udev.packages = [pkgs.gnome-settings-daemon];
      telepathy.enable = true;
      switcherooControl.enable = true;
      gnome = {
        core-developer-tools.enable = true;
        gnome-remote-desktop.enable = true;
        sushi.enable = true;
      };
    };

    programs = {
      gnupg.agent.pinentryPackage = pkgs.lib.mkForce pkgs.pinentry-gnome3;

      kdeconnect = {
        enable = true;
        package = pkgs.gnomeExtensions.gsconnect;
      };

      firefox = {
        nativeMessagingHosts.packages = [pkgs.gnomeExtensions.gsconnect];
        policies.ExtensionSettings = {
          name = "gnome-shell-integration";
          value = {
            installation_mode = "normal_installed";
            install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/chrome-gnome-shell@gnome.org/latest.xpi";
          };
        };
      };
    };

    # Screen Brightness
    hardware.i2c.enable = true;

    ## Package List
    environment.systemPackages = with pkgs; [
      ghostty
      gnome-boxes
      gnome-sound-recorder
      gnome-tweaks
      papers

      # Games
      gnome-chess
      gnome-mines
      quadrapassel

      # Circle
      apostrophe
      curtail
      deja-dup
      dialect
      fractal
      fragments
      gnome-decoder
      gnome-secrets
      gthumb
      lollypop
      resources
      upscaler
      video-trimmer
      wike
      wordbook

      # Utilities
      celluloid
      ddcutil
      gnuchess
    ];
  };

  home = _: {
    config = {
      stylix.targets = {
        gnome.enable = true;
        ghostty.enable = true;
      };

      # Default Applications
      xdg.mimeApps.defaultApplications = util.build.mime {
        archive = ["org.gnome.FileRoller.desktop"];
        audio = ["org.gnome.Lollypop.desktop"];
        calendar = ["org.gnome.Calendar.desktop"];
        document = ["org.gnome.Papers.desktop"];
        directory = ["org.gnome.Nautilus.desktop"];
        image = ["org.gnome.Loupe.desktop"];
        magnet = ["de.haeckerfelix.Fragments.desktop"];
        markdown = ["org.gnome.gitlab.somas.Apostrophe.desktop"];
        password = ["org.gnome.World.Secrets.desktop"];
        pdf = ["org.gnome.Papers.desktop"];
        text = ["org.gnome.TextEditor.desktop"];
        video = ["io.github.celluloid_player.Celluloid.desktop"];
        virtualization = ["org.gnome.Boxes.desktop"];
      };

      # Persisted Files
      home.persist.directories = [
        ".config/evolution"
        ".config/ghostty"
        ".config/gnome-boxes"
        ".config/gnome-builder"
        ".local/share/epiphany"
        ".local/share/evolution"
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

      ## Terminal
      programs.ghostty = {
        enable = true;
        settings = {
          # Features
          clipboard-paste-protection = true;
          clipboard-trim-trailing-spaces = true;
          copy-on-select = false;
          mouse-hide-while-typing = true;
          quit-after-last-window-closed = true;
          scrollback-limit = 4200;
          shell-integration-features = true;
          window-vsync = true;

          # Keybindings
          keybind = [
            "ctrl+h=goto_split:left"
            "ctrl+j=goto_split:bottom"
            "ctrl+k=goto_split:top"
            "ctrl+l=goto_split:right"
            "ctrl+shift+h=new_split:left"
            "ctrl+shift+j=new_split:down"
            "ctrl+shift+k=new_split:up"
            "ctrl+shift+l=new_split:right"
            "ctrl+shift+enter=new_split:auto"
            "ctrl+shift+i=inspector:toggle"
            "ctrl+shift+r=reload_config"
            "ctrl+t=new_tab"
          ];
        };
      };

      # Firefox GNOME Theme
      stylix.targets.firefox = {
        enable = true;
        profileNames = ["default"];
        firefoxGnomeTheme.enable = true;
      };
    };
  };
}

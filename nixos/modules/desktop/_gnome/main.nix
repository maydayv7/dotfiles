{
  util ? null,
  files ? null,
  inputs ? null,
  ...
}: {
  config,
  lib,
  pkgs,
  ...
} @ args: let
  inherit
    (lib)
    mkIf
    mkForce
    mkMerge
    ;
in {
  ## GNOME Configuration ##
  config = mkIf (config.gui.desktop == "gnome") (mkMerge [
    (import ./common.nix {inherit util files inputs;} args)

    {
      # Desktop Integration
      gui = {
        gtk = {
          enable = true;
          theme = {
            name = "adw-gtk3-dark";
            package = pkgs.adw-gtk3;
          };
        };

        qt = {
          enable = true;
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
        gnupg.agent.pinentryPackage = mkForce pkgs.pinentry-gnome3;
        nautilus-open-any-terminal = {
          enable = true;
          terminal = "ghostty";
        };

        kdeconnect = {
          enable = true;
          package = pkgs.gnomeExtensions.gsconnect;
        };

        firefox = {
          nativeMessagingHosts.gsconnect = true;
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
      user.groups = ["i2c"];
      hardware.i2c.enable = true;

      ## Package List
      environment.systemPackages = with pkgs; [
        ghostty
        gnome-boxes
        gnome-sound-recorder
        gnome-tweaks
        papers
        zenity

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

      user.homeConfig = {
        ## Desktop Settings
        imports = builtins.map (
          p:
            import p {
              inherit util files;
              sys = config;
            }
        ) (util.map.modules.list ./settings);
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
          mail = ["org.gnome.Geary.desktop"];
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
              "ctrl+f=write_scrollback_file:open"
            ];
          };
        };
      };
    }

    ## 3rd Party Apps Configuration
    {
      user.homeConfig = {
        config,
        lib,
        pkgs,
        ...
      }: {
        # Firefox GNOME Theme
        stylix.targets.firefox = {
          enable = lib.mkForce true;
          profileNames = ["default"];
          firefoxGnomeTheme.enable = true;
        };

        programs = {
          # Discord GNOME Theme
          nixcord.quickCss = lib.mkIf (config.programs.nixcord.enable or false) ''@import url("https://raw.githubusercontent.com/ricewind012/discord-gnome-theme/master/gnome.theme.css");'';

          # Code Editor
          vscode.profiles.default = lib.mkIf config.programs.vscode.enable {
            extensions = [pkgs.vscode-extensions.piousdeer.adwaita-theme];
            userSettings = {
              "workbench.colorTheme" = "Adwaita Dark";
              "workbench.productIconTheme" = "adwaita";
              "window.titleBarStyle" = "custom";
              "terminal.external.linuxExec" = "ghostty";
            };
          };
        };
      };

      # Logseq Bonofix Theme
      apps.logseq.style = "url('https://cdn.jsdelivr.net/gh/sansui233/logseq-bonofix-theme/custom.css')";

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
    }
  ]);
}

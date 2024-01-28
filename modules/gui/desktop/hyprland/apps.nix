{
  config,
  lib,
  util,
  pkgs,
  files,
  ...
}:
with files; let
  inherit (config.stylix) fonts;
  inherit (config.gui) wallpaper;
  exists = app: builtins.elem app config.apps.list;
  theme = import ./theme.nix pkgs;
in {
  environment.systemPackages = with pkgs; [
    # Apps
    geany
    gthumb
    lollypop
    mate.atril
    mission-center
    playerctl
    qalculate-gtk
    transmission-gtk
    xfce.thunar

    # Utilities
    grim
    grimblast
    slurp
    wev
    wl-clipboard
    wl-screenrec
    wlr-randr
  ];

  user = {
    # Persisted Files
    persist.directories = [
      ".config/geany"
      ".config/mpv"
      ".config/Thunar"
      ".local/share/lollypop"
    ];

    homeConfig = {
      # Default Applications
      xdg.mimeApps.defaultApplications = util.build.mime files.xdg.mime {
        audio = ["org.gnome.Lollypop.desktop"];
        directory = ["thunar.desktop"];
        image = ["org.gnome.gThumb.desktop"];
        magnet = ["transmission-gtk.desktop"];
        pdf = ["atril.desktop"];
        text = ["geany.desktop"];
        video = ["mpv.desktop"];
      };

      # Theming
      stylix.targets = {
        hyprland.enable = true;
        dunst.enable = true;
        swaylock = {
          enable = true;
          useImage = true;
        };
      };

      # Configuration Files
      home.file = {
        # Wallpaper
        ".config/hypr/hyprpaper.conf".text = ''
          preload = ${wallpaper}
          wallpaper = , ${wallpaper}
        '';

        # Text Editor
        ".config/geany/geany.conf".text = geany.settings;
        ".config/geany/colorschemes/theme.conf".text = geany.catppuccin;

        # Terminal
        ".config/kitty/search".source = pkgs.custom.kitty-search;

        # File Manager
        ".config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml".text = xfce.settings.thunar;
      };

      # Utilities
      services.playerctld.enable = true;

      # Terminal
      programs.kitty = {
        enable = true;
        font = fonts.monospace // {size = fonts.sizes.terminal;};
        theme = with theme; "${name-alt}-${variant-alt}";
        keybindings = {
          "ctrl+c" = "copy_or_interrupt";
          "kitty_mod+f" = "launch --allow-remote-control kitty +kitten search/search.py @active-kitty-window-id";
        };

        settings = {
          kitty_mod = "ctrl+shift";
          background_opacity = "0.9";
          placement_strategy = "center";

          copy_on_select = "clipboard";
          scrollback_lines = 10000;

          enable_audio_bell = "no";
          visual_bell_duration = "0.1";
        };
      };

      # Web Browser
      programs.firefox = {
        enable = true;
        policies.ExtensionSettings = {
          name = with theme; "${name}-${variant}-${accent}";
          value = {
            installation_mode = "normal_installed";
            install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/{d49033ac-8969-488c-afb0-5cdb73957f41}/latest.xpi";
          };
        };
      };

      # Media
      programs.mpv = {
        enable = true;
        defaultProfiles = ["gpu-hq"];
        scripts = [pkgs.mpvScripts.mpris];
      };

      # Notifications
      services.dunst = {
        enable = true;
        iconTheme = theme.icons;
        settings = {
          fullscreen_delay_everything = {fullscreen = "delay";};
          global = {
            alignment = "center";
            corner_radius = 10;
            follow = "mouse";
            format = "<b>%s</b>\\n%b";
            frame_width = 1;
            offset = "5x5";
            horizontal_padding = 8;
            icon_position = "left";
            indicate_hidden = "yes";
            markup = "yes";
            max_icon_size = 64;
            mouse_left_click = "do_action";
            mouse_middle_click = "close_all";
            mouse_right_click = "close_current";
            padding = 8;
            plain_text = "no";
            separator_height = 1;
            show_indicators = false;
            shrink = "no";
            word_wrap = "yes";
          };
        };
      };

      # Locker
      programs.swaylock = {
        enable = true;
        package = pkgs.swaylock-effects;
        settings = {
          clock = true;
          indicator = true;
          font = fonts.sansSerif.name;
          grace = 10;
          fade-in = 1;
          effect-vignette = "0.3:1";
        };
      };

      # Screen Idle
      services.swayidle = {
        enable = true;
        events = [
          {
            event = "before-sleep";
            command = "${pkgs.systemd}/bin/loginctl lock-session";
          }
          {
            event = "lock";
            command = "${pkgs.swaylock-effects}/bin/swaylock -f";
          }
        ];
        timeouts = [
          {
            timeout = 330;
            command = "${pkgs.writeShellApplication {
              name = "suspend"; # Only suspend if no audio is playing
              runtimeInputs = with pkgs; [pipewire ripgrep systemd];
              text = ''
                pw-cli i all | rg running
                if [ $? == 1 ]
                then
                  ${pkgs.systemd}/bin/systemctl suspend
                fi
              '';
            }}/bin/suspend";
          }
        ];
      };

      systemd.user.services = {
        # Wallpaper Daemon
        hyprpaper = {
          Install.WantedBy = ["graphical-session.target"];
          Unit = {
            Description = "Hyprland Wallpaper Daemon";
            PartOf = ["graphical-session.target"];
          };

          Service = {
            ExecStart = "${lib.getExe pkgs.hyprpaper}";
            Restart = "on-failure";
          };
        };

        # Authorization Agent
        polkit = {
          Unit.Description = "polkit-gnome-authentication-agent-1";

          Install = {
            WantedBy = ["graphical-session.target"];
            Wants = ["graphical-session.target"];
            After = ["graphical-session.target"];
          };

          Service = {
            Type = "simple";
            ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
        };
      };

      ## 3rd Party Apps Configuration
      # Code Editor
      programs.vscode = lib.mkIf (exists "vscode") {
        extensions = with pkgs.vscode-extensions.catppuccin; [catppuccin-vsc catppuccin-vsc-icons];
        userSettings = with theme; {
          "workbench.colorTheme" = "${name-alt} ${variant-alt}";
          "workbench.iconTheme" = "${name}-${variant}";
          "catppuccin.accentColor" = "${accent}";
          "terminal.external.linuxExec" = "kitty";
        };
      };
    };
  };
}

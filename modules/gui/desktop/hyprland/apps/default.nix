{
  config,
  lib,
  util,
  pkgs,
  files,
  ...
}:
with files; let
  inherit (config.gui) wallpaper;
  inherit (lib) getExe mkIf;
  exists = app: builtins.elem app config.apps.list;
  theme = import ../theme.nix pkgs;
in {
  apps.list = ["firefox"];
  gui.launcher.terminal = "kitty";
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

  # File Manager
  services.tumbler.enable = true;
  programs = {
    xfconf.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    # Apps
    apostrophe
    celluloid
    font-manager
    geany
    gnome.file-roller
    lollypop
    mate.atril
    mission-center
    custom.nwg-clipman
    nwg-displays
    custom.nwg-drawer
    unstable.overskride
    playerctl
    qalculate-gtk
    remmina
    shotwell
    transmission-gtk

    # Utilities
    cliphist
    grim
    unstable.grimblast
    hyprkeys
    pavucontrol
    slurp
    wev
    wl-clipboard
    wl-screenrec
    wlr-randr
    xfce.exo
  ];

  user = {
    # Persisted Files
    persist.directories = [
      ".config/geany"
      ".config/mpv"
      ".config/nwg-displays"
      ".config/shotwell"
      ".config/Thunar"
      ".local/share/lollypop"
      ".local/share/shotwell"
      ".cache/cliphist"
      ".cache/shotwell"
    ];

    homeConfig = {
      imports = util.map.modules.list ./.;

      # Default Applications
      xdg.mimeApps.defaultApplications = util.build.mime files.xdg.mime {
        audio = ["org.gnome.Lollypop.desktop"];
        directory = ["thunar.desktop"];
        image = ["org.gnome.Shotwell-Viewer.desktop"];
        magnet = ["transmission-gtk.desktop"];
        markdown = ["org.gnome.gitlab.somas.Apostrophe.desktop"];
        pdf = ["atril.desktop"];
        text = ["geany.desktop"];
        video = ["io.github.celluloid_player.Celluloid.desktop"];
      };

      # Shortcuts
      wayland.windowManager.hyprland.settings.bind = [
        "$mod, A, exec, nwg-drawer"
        "$mod, D, exec, nwg-displays"
        "$mod, F, exec, thunar"
        "$mod, N, exec, dunstctl history-pop"
        "$mod, T, exec, kitty"
        "$mod, V, exec, nwg-clipman -nw"
        "$mod, W, exec, firefox"
        "$mod, slash, exec, ulauncher-toggle"
        "$mod, Return, exec, missioncenter"
        ", XF86Calculator, exec, qalculate-gtk"
        "$mod, Escape, exec, wlogout -p layer-shell"
      ];

      # Autostart
      wayland.windowManager.hyprland.settings.exec-once = [
        # Application Drawer
        "nwg-drawer -r"

        # Clipboard
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
      ];

      # Utilities
      services.playerctld.enable = true;
      services.poweralertd.enable = true;

      # Terminal
      wayland.windowManager.hyprland.settings.misc.swallow_regex = "^(kitty)$";
      programs.kitty = {
        enable = true;
        font = with config.stylix.fonts; monospace // {size = sizes.terminal;};
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
      stylix.targets.dunst.enable = true;
      services.dunst = {
        enable = true;
        iconTheme = theme.icons;
        settings =
          {
            global = {
              alignment = "center";
              corner_radius = 10;
              follow = "mouse";
              format = "<b>%s</b>\\n%b";
              frame_width = 1;
              horizontal_padding = 8;
              icon_corner_radius = 10;
              icon_position = "left";
              icon_theme = theme.icons.name;
              indicate_hidden = "yes";
              markup = "yes";
              max_icon_size = 64;
              mouse_left_click = "do_action";
              mouse_middle_click = "close_all";
              mouse_right_click = "close_current";
              offset = "5x5";
              padding = 8;
              plain_text = "no";
              progress_bar_corner_radius = 10;
              separator_height = 1;
              show_indicators = false;
              shrink = "no";
              transparency = 10;
              word_wrap = "yes";
            };
          }
          // (let
            ignore = {
              history_ignore = "yes";
              fullscreen = "show";
            };
          in {
            fullscreen_delay = {fullscreen = "delay";};
            power = {appname = "poweralertd";} // ignore;
            utility = {appname = "utility";} // ignore;
          });
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
            ExecStart = getExe pkgs.hyprpaper;
            Restart = "on-failure";
          };
        };

        # Screen Share
        xwaylandvideobridge = {
          Unit.Description = "Stream Wayland windows to apps running under Xwayland";
          Install.wantedBy = ["graphical-session.target"];
          Service = {
            ExecStart = getExe pkgs.xwaylandvideobridge;
            Restart = "on-failure";
          };
        };
      };

      # Configuration Files
      home.file =
        {
          # Application Drawer
          ".config/nwg-drawer/drawer.css".text = nwg.drawer;

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
          ".config/xfce4/helpers.rc".text = ''
            TerminalEmulator=kitty
            TerminalEmulatorDismissed=true
          '';

          # File Manager
          ".config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml" = {
            text = xfce.settings.thunar;
            force = true;
          };
        }
        ## 3rd Party Apps Configuration
        // {
          # Discord Chat
          ".config/BetterDiscord/data/stable/custom.css" = with theme;
            mkIf (exists "discord") {text = ''@import url("https://${name}.github.io/discord/dist/${name}-${variant}-${accent}.theme.css");'';};
        };

      # Code Editor
      programs.vscode = mkIf (exists "vscode") {
        extensions = with pkgs; [
          vscode-extensions.catppuccin.catppuccin-vsc-icons
          (catppuccin-vsc.override {
            inherit (theme) accent;
            boldKeywords = true;
            italicComments = true;
            italicKeywords = true;
            extraBordersEnabled = false;
            workbenchMode = "default";
            bracketMode = "rainbow";
          })
        ];

        userSettings = with theme; {
          "workbench.colorTheme" = "${name-alt} ${variant-alt}";
          "workbench.iconTheme" = "${name}-${variant}";
          "terminal.external.linuxExec" = "kitty";
        };
      };
    };
  };
}

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
    blueberry
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
      imports = util.map.modules.list ./.;

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

      # Shortcuts
      wayland.windowManager.hyprland.settings.bind = [
        "$mod, F, exec, thunar"
        "$mod, T, exec, kitty"
        "$mod, W, exec, firefox"
        "$mod, Return, exec, missioncenter"
        "$mod, slash, exec, ulauncher-toggle"
        ", XF86Calculator, exec, qalculate-gtk"
      ];

      # Utilities
      services.playerctld.enable = true;

      # Terminal
      wayland.windowManager.hyprland.settings.misc.swallow_regex = " ^(kitty)$";
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

      # Wallpaper Daemon
      systemd.user.services.hyprpaper = {
        Install.WantedBy = ["graphical-session.target"];
        Unit = {
          Description = "Hyprland Wallpaper Daemon";
          PartOf = ["graphical-session.target"];
        };

        Service = {
          ExecStart = "${getExe pkgs.hyprpaper}";
          Restart = "on-failure";
        };
      };

      # Configuration Files
      home.file =
        {
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
{
  sys,
  lib,
  pkgs,
  files,
  ...
}: let
  theme = import ../theme.nix pkgs;
in rec {
  ## Bar Configuration
  stylix.targets.waybar = {
    enable = true;
    enableCenterBackColors = true;
    enableLeftBackColors = true;
    enableRightBackColors = true;
  };

  # Environment Setup
  home.packages = [pkgs.wttrbar];
  systemd.user = {
    # nix-community/home-manager/4099
    services.waybar.Service.ExecStart = lib.mkForce (pkgs.writeShellScript "waybar-wrapper.sh" ''
      ${files.path.systemd}
      ${lib.getExe programs.waybar.package}
    '');

    # nix-community/home-manager/2064
    targets.tray = {
      Unit = {
        Description = "Home Manager System Tray";
        Requires = ["graphical-session-pre.target"];
      };
    };
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    package = pkgs.waybar;
    style = files.hyprland.waybar;

    # Panel
    settings = [
      {
        layer = "top";
        position = "top";

        height = 30;
        spacing = 3;
        margin-top = 3;
        margin-right = 5;
        margin-bottom = 5;
        margin-left = 5;

        modules-left = [
          "custom/logo"
          "group/users"
          "hyprland/workspaces"
          "hyprland/submap"
          "hyprland/window"
        ];

        modules-center = ["wlr/taskbar"];
        modules-right = [
          "group/menu"
          "bluetooth"
          "network"
          "group/media"
          "backlight"
          "group/power"
          "custom/weather"
          "clock"
          "group/notify"
        ];

        "custom/logo" = {
          format = "";
          tooltip = false;
          on-click = "nwg-drawer";
          on-click-right = "hyprctl dispatch hycov:toggleoverview";
        };

        "group/users" = {
          orientation = "horizontal";
          modules = ["user" "custom/power"];
          drawer.transition-left-to-right = true;
        };

        user = {
          format = "{user}";
          icon = true;
          height = 30;
          width = 30;
          open-on-click = true;
        };

        "custom/power" = {
          format = "";
          tooltip = false;
          on-click = "wlogout -p layer-shell";
        };

        "hyprland/workspaces" = {
          all-outputs = true;
          show-special = true;
          format = "{icon}";
          on-scroll-up = "hyprctl dispatch workspace m+1";
          on-scroll-down = "hyprctl dispatch workspace m-1";
          persistent-workspaces."${sys.gui.display}" = 3;
          ignore-workspaces = ["special:scratch_.*"];
          format-icons = {
            default = "";
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "6" = "";
            "7" = "";
            "8" = "";
            "9" = "";
            OVERVIEW = "";
            special = "";
            "special:minimized" = "";
          };
        };

        "hyprland/submap" = {
          always-on = false;
          tooltip = false;
          format = " {}";
          on-click = "hyprctl dispatch submap reset";
        };

        "hyprland/window" = {
          format = "{initialTitle}";
          max-length = 40;
          separate-outputs = true;
          rewrite = {
            "bash" = "Terminal";
            "zsh" = "Terminal";
            "kitty" = "Terminal";
            "(.*) - kitty" = "Terminal";
            "clipse" = "Clipboard";
            "nwg-displays" = "Displays";
            "Ulauncher(.*)" = "Launcher";
            "(.*) - Geany" = "Text Editor";
            "(.*) - Thunar" = "File Manager";
          };
        };

        "wlr/taskbar" = {
          format = "{icon}";
          icon-size = 20;
          all-outputs = false;
          active-first = false;
          icon-theme = theme.icons.name;
          markup = true;
          tooltip-format = "Name: <big><b>{name}</b></big> <i>{short_state}</i>\nTitle: <b>{title}</b>";
          on-click = "activate";
          on-click-middle = "fullscreen";
          on-click-right = "close";
          ignore-list = [
            "kitty-clip"
            "kitty-dropterm"
            "ulauncher"
          ];
        };

        "group/menu" = {
          orientation = "horizontal";
          modules = ["custom/dropdown" "keyboard-state" "tray"];
          drawer.transition-left-to-right = true;
        };

        "custom/dropdown" = {
          format = "";
          tooltip = false;
        };

        tray.icon-size = 14;
        keyboard-state = {
          numlock = true;
          capslock = true;
          format = {
            numlock = " N {icon}";
            capslock = "󰪛 {icon}";
          };
          format-icons = {
            locked = "";
            unlocked = "";
          };
        };

        bluetooth = {
          format = "";
          format-disabled = "󰂳";
          format-connected = "󰂱 {num_connections}";
          tooltip-format = " {status}";
          tooltip-format-connected = "{device_enumerate}";
          tooltip-format-enumerate-connected = " {device_alias} 󰂄 {device_battery_percentage}%";
          on-click = "pypr show bluetooth";
        };

        network = {
          format = "{ifname}";
          format-disconnected = "󰌙";
          format-ethernet = "󰌘";
          format-wifi = "{icon}";
          format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
          format-linked = "󰈁 {ifname}";
          tooltip-format = "Network: <big><b>{essid}</b></big>\nStrength: <b>{signaldBm}dBm ({signalStrength}%)</b>\nFrequency: <b>{frequency}MHz</b>\nInterface: <b>{ifname}</b>\nIP: <b>{ipaddr}/{cidr}</b>\nGateway: <b>{gwaddr}</b>\nNetmask: <b>{netmask}</b>";
          tooltip-format-disconnected = "󰌙 Disconnected";
          on-click = "pypr show network";
        };

        "group/media" = {
          orientation = "horizontal";
          modules = ["wireplumber" "mpris"];
          drawer.transition-left-to-right = true;
        };

        wireplumber = {
          max-volume = 150;
          scroll-step = 1;
          reverse-scrolling = 1;
          format = "{icon}";
          tooltip-format = "Volume: {volume}%\nDevice: {node_name}";
          format-muted = "";
          format-icons = ["" "" "󰕾" ""];
          on-click = "pypr show volume";
        };

        mpris = {
          dynamic-len = 20;
          dynamic-importance-order = ["title" "position" "length" "artist"];
          dynamic-separator = "";
          format = " {player} {dynamic}";
          format-paused = "󰏤 <i>{player}</i>";
          format-stopped = "";
          tooltip-format-stopped = "Not Playing";
        };

        backlight = {
          format = "{icon}";
          tooltip-format = "Backlight: {percent}%";
          format-icons = ["" "" "" "" "" "" "" "" ""];
          on-scroll-down = "brillo -u 300000 -A 5";
          on-scroll-up = "brillo -u 300000 -U 5";
          on-click = "pypr show displays";
        };

        "group/power" = {
          orientation = "horizontal";
          modules = ["battery" "power-profiles-daemon"];
          drawer.transition-left-to-right = true;
        };

        battery = {
          interval = 5;
          align = 0;
          rotate = 0;
          format = "{icon}";
          tooltip-format = "Battery: {capacity}%";
          format-charging = "";
          format-icons = ["" "" "" "" ""];
          on-click-right = "hyprutils toggle fancy";
          states = {
            good = 80;
            warning = 20;
            critical = 10;
          };
        };

        power-profiles-daemon = {
          format = "{icon}";
          tooltip = true;
          tooltip-format = "Power Profile: {profile}";
          format-icons = {
            default = "";
            performance = "";
            balanced = "";
            power-saver = "";
          };
        };

        "custom/weather" = {
          format = "{}°";
          tooltip = true;
          interval = 3600;
          exec = "wttrbar";
          return-type = "json";
        };

        clock = {
          interval = 1;
          format = " {:%H:%M:%S}";
          format-alt = "  {:%I:%M   %Y, %d %B, %A}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "left";
            on-scroll = 1;
            format = with sys.lib.stylix.colors; {
              months = "<span color='#${base06}'><b>{}</b></span>";
              days = "<span color='#${base05}'><b>{}</b></span>";
              weeks = "<span color='#${base0C}'><b>W{}</b></span>";
              weekdays = "<span color='#${base0A}'><b>{}</b></span>";
              today = "<span color='#${base08}'><b><u>{}</u></b></span>";
            };
          };

          actions = {
            on-click-right = "mode";
            on-click-forward = "tz_up";
            on-click-backward = "tz_down";
            on-scroll-up = "shift_down";
            on-scroll-down = "shift_up";
          };
        };

        "group/notify" = {
          orientation = "horizontal";
          modules = ["custom/dunst" "idle_inhibitor"];
          drawer.transition-left-to-right = true;
        };

        "custom/dunst" = {
          tooltip = false;
          on-click = "dunstctl history-pop";
          on-click-right = "dunstctl set-paused toggle";
          restart-interval = 1;
          exec = with pkgs; "${writeShellApplication {
            name = "notify";
            runtimeInputs = [coreutils dunst];
            text = ''
              COUNT=$(dunstctl count waiting)
              ENABLED=""
              DISABLED=""
              if [ "$COUNT" != 0 ]; then DISABLED=" $COUNT"; fi
              if dunstctl is-paused | grep -q "false" ; then echo "$ENABLED"; else echo "$DISABLED"; fi
            '';
          }}/bin/notify";
        };

        idle_inhibitor = {
          format = "{icon}";
          on-click = "hyprutils toggle idle";
          tooltip-format-activated = "Idle Inhibitor: On";
          tooltip-format-deactivated = "Idle Inhibitor: Off";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
      }
    ];
  };
}

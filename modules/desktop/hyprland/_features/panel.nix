{files ? null, ...}: {
  home = {
    config,
    lib,
    pkgs,
    osConfig ? null,
    ...
  }: let
    inherit (lib) mkDefault mkIf mkMerge;
  in {
    stylix.targets.waybar = {
      enable = true;
      font = "sansSerif";
      addCss = false;
    };

    home.packages = [pkgs.wttrbar];
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      package = pkgs.waybar;
      style = files.hyprland.waybar;
      settings = mkIf (osConfig != null) (let
        inherit (osConfig.gui) display;
        shared = {
          layer = "top";
          position = "top";
          height = 40;
          spacing = 3;
          margin-top = 2;
          margin-right = 5;
          margin-bottom = 1;
          margin-left = 5;

          "custom/logo" = {
            format = "󱄅";
            tooltip = false;
            on-click = "nwg-drawer";
          };

          "group/users" = {
            orientation = "horizontal";
            modules = [
              "user"
              "custom/power"
            ];
            drawer.transition-left-to-right = true;
          };

          user = {
            format = "{user}";
            open-on-click = true;
            icon = true;
            height = 22;
            width = 22;
          };

          "custom/user" = {
            exec = "sh -c 'getent passwd $USER | cut -d : -f 5'";
            format = "{}";
            rotate = 270;
            tooltip = false;
            on-click = "sh -c 'nemo ~'";
          };

          "custom/power" = {
            format = "⏻";
            tooltip = false;
            on-click = "wlogout -p layer-shell";
          };

          "hyprland/submap" = {
            always-on = false;
            tooltip = false;
            format = " {}";
            on-click = "hyprctl dispatch submap reset";
          };

          "hyprland/window" = {
            format = "{class}";
            icon = false;
            separate-outputs = true;
          };

          "hyprland/workspaces" = {
            all-outputs = false;
            show-special = true;
            format = "<small>{name}</small>{windows}";
            on-scroll-up = "hyprctl dispatch workspace m+1";
            on-scroll-down = "hyprctl dispatch workspace m-1";
            ignore-workspaces = [
              "special:S-.*"
              "special:minimized"
            ];

            workspace-taskbar = {
              enable = true;
              format = "{icon}";
              icon-size = 22;
              icon-theme = config.stylix.icons.dark;
              on-click-window = "hyprutils click {button} {address}";
              ignore-list = [
                "kitty-clip"
                "kitty-dropterm"
              ];
            };
          };

          "custom/minimized" = {
            format = "";
            on-click = "hyprutils toggle minimized";
          };

          "group/menu" = {
            modules = [
              "custom/hide"
              "keyboard-state"
              "tray"
            ];
            orientation = "horizontal";
            drawer = {
              click-to-reveal = true;
              transition-left-to-right = true;
            };
          };

          "custom/hide" = {
            format = mkDefault "";
            tooltip = false;
          };

          keyboard-state = {
            numlock = true;
            capslock = true;
            format = {
              numlock = mkDefault " N {icon}";
              capslock = mkDefault "󰪛 {icon}";
            };
            format-icons = {
              locked = "";
              unlocked = "";
            };
          };

          bluetooth = {
            format = "";
            format-disabled = "󰂳";
            format-connected = "󰂱 {num_connections}";
            tooltip-format = " {status}";
            tooltip-format-connected = "{device_enumerate}";
            tooltip-format-enumerate-connected = " {device_alias} 󰂄 {device_battery_percentage}%";
            on-click = "overskride";
          };

          network = let
            tooltip = "Strength: <b>{signaldBm}dBm ({signalStrength}%)</b>\nFrequency: <b>{frequency}MHz</b>\nInterface: <b>{ifname}</b>\nIP: <b>{ipaddr}/{cidr}</b>\nGateway: <b>{gwaddr}</b>\nNetmask: <b>{netmask}</b>";
          in {
            format = "?";
            format-disconnected = "󰌙";
            format-wifi = "{icon}";
            format-ethernet = "󰌘";
            format-icons = [
              "󰤯"
              "󰤟"
              "󰤢"
              "󰤥"
              "󰤨"
            ];
            format-linked = "󰈁";
            tooltip-format-wifi = "Network: <big><b>{essid}</b></big>\n${tooltip}";
            tooltip-format-ethernet = "Network: <big><b>Wired</b></big>\n${tooltip}";
            tooltip-format-disconnected = "󰌙 Disconnected";
            on-click = "sh -c 'env XDG_CURRENT_DESKTOP=GNOME gnome-control-center wifi'";
          };

          "group/media" = {
            modules = [
              "wireplumber"
              "mpris"
            ];
            orientation = "horizontal";
            drawer = {
              click-to-reveal = true;
              transition-left-to-right = true;
              transition-duration = 1000;
            };
          };

          wireplumber = {
            max-volume = 150;
            scroll-step = 1;
            reverse-scrolling = 1;
            format = "{icon}";
            tooltip-format = "Volume: {volume}%\nDevice: {node_name}";
            format-icons = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
            format-muted = "";
            on-click = "pwvucontrol";
          };

          mpris = {
            dynamic-len = 20;
            dynamic-order = [
              "title"
              "artist"
              "length"
            ];
            dynamic-separator = " - ";
            format = mkDefault " {player}";
            format-paused = mkDefault "󰏤 <i>{player}</i>";
            format-stopped = "";
            tooltip-format-stopped = "Not Playing";
            on-click = "sysutils media toggle";
            on-click-right = "sysutils media next";
            on-click-middle = "sysutils media previous";
          };

          "group/display" = {
            modules = [
              "backlight"
              "custom/temperature"
            ];
            orientation = "horizontal";
            drawer.transition-left-to-right = true;
          };

          backlight = {
            format = "{icon}";
            tooltip-format = "Backlight: {percent}%";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
            ];
            on-scroll-up = "sysutils brightness down";
            on-scroll-down = "sysutils brightness up";
            on-click = "nwg-displays";
          };

          "custom/temperature" = {
            format = "";
            tooltip = false;
            on-click = "sysutils temperature";
          };

          "group/power" = {
            modules = [
              "battery"
              "power-profiles-daemon"
            ];
            orientation = "horizontal";
            drawer.transition-left-to-right = false;
          };

          battery = {
            interval = 5;
            align = 0;
            rotate = 0;
            format = "{icon}";
            on-click-right = "hyprutils toggle fancy";
            tooltip-format = "Battery: {capacity}%";
            format-charging = "";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
            ];
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
              default = "";
              performance = "󱄟";
              balanced = "";
              power-saver = "";
            };
          };

          "custom/weather" = {
            format = mkDefault "{}°";
            return-type = "json";
            exec = mkDefault "wttrbar --date-format %d/%m --nerd";
            tooltip = true;
            interval = 600;
            signal = 7;
            on-click = "pkill -RTMIN+7 waybar";
          };

          clock = {
            interval = 1;
            format = mkDefault "󰅐 {:%H:%M:%S} ";
            format-alt = mkDefault "󰅐 {:%I:%M    %A, %d %B %Y} ";
            tooltip-format = "<tt><small>{calendar}</small></tt>";
            calendar = {
              mode = "year";
              mode-mon-col = 3;
              weeks-pos = "left";
              on-scroll = 1;
              format = with config.lib.stylix.colors; {
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
            modules = [
              "custom/notify"
              "idle_inhibitor"
            ];
            orientation = "horizontal";
            drawer.transition-left-to-right = false;
          };

          "custom/notify" = {
            exec = "swaync-client -swb";
            exec-if = "which swaync-client";
            on-click = "swaync-client -t -sw";
            on-click-right = "swaync-client -d -sw";
            return-type = "json";
            escape = true;
            tooltip = false;
            format = "{icon}";
            format-icons = {
              none = "";
              notification = "";
              dnd-none = "";
              dnd-notification = "";
              inhibited-none = "";
              inhibited-notification = "";
              dnd-inhibited-none = "";
              dnd-inhibited-notification = "";
            };
          };

          idle_inhibitor = {
            format = "{icon}";
            on-click = "sysutils toggle service swayidle";
            tooltip-format-activated = "Idle Inhibitor: On";
            tooltip-format-deactivated = "Idle Inhibitor: Off";
            format-icons = {
              activated = "";
              deactivated = "";
            };
          };

          modules-left = [
            "custom/logo"
            "group/users"
            "hyprland/workspaces"
            "custom/minimized"
          ];

          modules-center = [
            "hyprland/window"
            "hyprland/submap"
          ];
        };
      in [
        (mkMerge [
          shared
          {
            output = display;
            modules-right = [
              "group/menu"
              "bluetooth"
              "network"
              "group/media"
              "group/display"
              "group/power"
              "custom/weather"
              "clock"
              "group/notify"
            ];
          }
        ])
        (mkMerge [
          shared
          {
            output = "!" + display;
            modules-right = [
              "group/menu"
              "bluetooth"
              "network"
              "group/media"
              "group/power"
              "custom/weather"
              "clock"
              "group/notify"
            ];
          }
        ])
      ]);
    };
  };
}

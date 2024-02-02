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
  home.packages = with pkgs; [font-awesome wttrbar];
  systemd.user = {
    # nix-community/home-manager/4099
    services.waybar.Service.ExecStart = lib.mkForce (pkgs.writeShellScript "waybar-wrapper.sh" ''
      ${files.path.systemd}
      ${programs.waybar.package}/bin/waybar
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

    package = pkgs.waybar.overrideAttrs (old: {
      version = "hypr";
      nativeCheckInputs = [pkgs.unstable.catch2_3];
      src = pkgs.fetchFromGitHub {
        owner = "Syndelis";
        repo = "Waybar";
        rev = "1bf97f532e5aac74fe9e9ca61500c3e26b14422f";
        sha256 = "sha256-kAaMoFqaJ9qUVztpLJWiZAq/EKHuhJFBbGyuGbINq/U=";
      };
    });

    # Panel
    settings = [
      {
        layer = "top";
        position = "top";
        output = ["eDP-1"];

        spacing = 3;
        margin-top = 3;
        margin-left = 5;
        margin-right = 5;
        margin-bottom = 5;

        modules-left = ["custom/logo" "hyprland/workspaces" "hyprland/window"];
        modules-center = ["wlr/taskbar"];
        modules-right = [
          "tray"
          "bluetooth"
          "network"
          "keyboard-state"
          "backlight"
          "wireplumber"
          "battery"
          "clock"
          "custom/weather"
        ];

        "custom/logo" = {
          format = "";
          tooltip = false;
          on-click = "wlogout -p layer-shell";
        };

        "hyprland/workspaces" = {
          all-outputs = true;
          show-special = true;
          format = "{icon}";
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
          format-icons = {
            default = "";
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "🖧";
            "5" = "";
            "6" = "";
            "7" = "";
            "8" = "";
            "9" = "";
            "10" = "";
            special = "";
          };

          persistent-workspaces = {
            "*" = 3;
          };
        };

        "hyprland/window" = {
          format = "{initialTitle}";
          max-length = 40;
          separate-outputs = true;
          rewrite = {
            "bash" = "Terminal";
            "zsh" = "Terminal";
            "(.*) - kitty" = "Terminal";
            "Ulauncher(.*)" = "Launcher";
          };
        };

        "wlr/taskbar" = {
          format = "{icon}";
          icon-size = 16;
          all-outputs = false;
          icon-theme = theme.icons.name;
          tooltip-format = "{title}";
          on-click = "activate";
          on-click-middle = "close";
        };

        tray = {
          icon-size = 14;
          spacing = 8;
        };

        bluetooth = {
          format = "";
          format-disabled = "󰂳";
          format-connected = "󰂱 {num_connections}";
          tooltip-format = " {status}";
          tooltip-format-connected = "{device_enumerate}";
          tooltip-format-enumerate-connected = " {device_alias} 󰂄 {device_battery_percentage}%";
          on-click = "blueberry";
        };

        network = {
          format = "{ifname}";
          format-disconnected = "󰌙";
          format-ethernet = "󰌘";
          format-wifi = "{icon}";
          format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
          format-linked = "󰈁 {ifname}";
          tooltip-format = "Network= <big><b>{essid}</b></big>\nStrength= <b>{signaldBm}dBm ({signalStrength}%)</b>\nFrequency= <b>{frequency}MHz</b>\nInterface= <b>{ifname}</b>\nIP= <b>{ipaddr}/{cidr}</b>\nGateway= <b>{gwaddr}</b>\nNetmask= <b>{netmask}</b>";
          tooltip-format-disconnected = "󰌙 Disconnected";
          on-click = "kitty nmtui";
        };

        keyboard-state = {
          numlock = true;
          capslock = false;
          format.numlock = "NUM {icon}";
          format-icons = {
            locked = "";
            unlocked = "*";
          };
        };

        backlight = {
          format = "{icon}";
          tooltip-format = "Backlight {percent}%";
          format-icons = ["" "" "" "" "" "" "" "" ""];
          on-scroll-down = "${pkgs.brillo}/bin/brillo -u 300000 -A 5";
          on-scroll-up = "${pkgs.brillo}/bin/brillo -u 300000 -U 5";
        };

        wireplumber = {
          max-volume = 150;
          scroll-step = 1;
          format = "{icon} {volume}%";
          format-muted = " Mute";
          format-icons = ["" "" "󰕾" ""];
        };

        battery = {
          interval = 10;
          align = 0;
          rotate = 0;
          format = "{icon}";
          tooltip-format = "Battery {capacity}%";
          format-charging = "";
          format-icons = ["" "" "" "" ""];
          states = {
            good = 80;
            warning = 20;
            critical = 10;
          };
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
            format = {
              months = "<span color='#FFEAD3'><b>{}</b></span>";
              days = "<span color='#ECC6D9'><b>{}</b></span>";
              weeks = "<span color='#99FFDD'><b>W{}</b></span>";
              weekdays = "<span color='#FFCC66'><b>{}</b></span>";
              today = "<span color='#FF6699'><b><u>{}</u></b></span>";
            };
          };

          actions = {
            on-click-right = "mode";
            on-click-forward = "tz_up";
            on-click-backward = "tz_down";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };

        "custom/weather" = {
          format = "{}°";
          tooltip = true;
          interval = 3600;
          exec = "wttrbar";
          return-type = "json";
        };
      }
    ];

    style = ''
      * {
        font-family: ${sys.stylix.fonts.sansSerif.name}, "Font Awesome 6 Free";
        font-size: 16px;
        font-weight: 500;
        border-radius: 10px;
      }

      #waybar.empty #window { background: none; }
      #taskbar button.active { background: @base03; }
      .modules-right #clock { background-color: @base0A; }

      #custom-logo {
        color: @base00;
        background-color: @base06;
      }

      #custom-weather {
        color: @base00;
        background-color: @base08;
      }

      #backlight,
      #battery,
      #bluetooth,
      #clock,
      #custom-weather,
      #keyboard-state,
      #taskbar,
      #tray,
      #window,
      #wireplumber,
      #workspaces { padding: 3px 6px 3px 6px; }
      #network,
      #custom-logo { padding: 3px 11px 3px 6px; }
    '';
  };
}

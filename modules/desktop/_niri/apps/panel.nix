{files ? null, ...}: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkMerge;
  inherit (config._shared) panel;
  inherit (config.gui) display;
in {
  ## Panel Configuration
  user.homeConfig.programs.waybar = {
    style = files.niri.waybar;
    settings = let
      shared = {
        position = "left";
        width = 40;
        spacing = 3;
        margin = "0";

        "group/users" = {
          orientation = "vertical";
          modules = [
            "custom/user"
            "custom/power"
          ];
          drawer.transition-left-to-right = false;
        };

        "niri/workspaces" = {
          all-outputs = false;
          format = "<small>{value}</small>";
        };

        "niri/window" = {
          format = "";
          icon = true;
          icon-size = 20;
          separate-outputs = true;
        };

        "group/menu" = {
          orientation = "vertical";
          drawer.transition-left-to-right = false;
        };

        keyboard-state.format = {
          numlock = " N\n{icon}";
          capslock = "󰪛\n{icon}";
        };

        "group/media" = {
          orientation = "vertical";
          drawer.transition-left-to-right = true;
        };

        mpris = {
          format = "";
          format-paused = "󰏤";
        };

        "group/power" = {
          orientation = "vertical";
          drawer.transition-left-to-right = true;
        };

        "group/display" = {
          orientation = "vertical";
          drawer.transition-left-to-right = true;
        };

        "custom/hide".format = "";

        "custom/weather" = {
          format = "{}";
          hide-empty-text = true;
          exec = "${
            pkgs.writeShellApplication {
              name = "weather";
              runtimeInputs = with pkgs; [
                coreutils
                wttrbar
              ];
              text = ''
                WEATHER=$(wttrbar --date-format %d/%m --nerd --vertical-view)
                if [[ $WEATHER = *wttr.in* ]]
                then
                  echo "{}"
                else
                  echo "$WEATHER"
                fi
              '';
            }
          }/bin/weather";
        };

        clock = {
          format = "󰅐\n{:%H\n%M\n%S} ";
          format-alt = "󰅐\n{:%I\n%M\n\n%d\n%m\n%y} ";
        };

        "group/notify" = {
          orientation = "vertical";
          drawer.transition-left-to-right = true;
        };

        modules-right = [
          "group/menu"
          "group/users"
          "custom/logo"
        ];

        modules-center = [
          "niri/window"
          "niri/workspaces"
        ];
      };
    in [
      (mkMerge [
        panel
        shared
        {
          output = display;
          modules-left = [
            "group/notify"
            "clock"
            "custom/weather"
            "group/power"
            "group/display"
            "group/media"
            "network"
            "bluetooth"
          ];
        }
      ])
      (mkMerge [
        panel
        shared
        {
          output = "!" + display;
          modules-left = [
            "group/notify"
            "clock"
            "group/power"
            "group/media"
            "network"
            "bluetooth"
          ];
        }
      ])
    ];
  };
}

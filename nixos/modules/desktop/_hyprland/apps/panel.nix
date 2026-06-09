{files ? null, ...}: {
  config,
  lib,
  ...
}: let
  inherit (lib) mkMerge;
  inherit (config._shared) panel theme;
  inherit (config.gui) display;
in {
  ## Panel Configuration
  user.homeConfig.programs.waybar = {
    style = files.hyprland.waybar;
    settings = let
      shared = {
        position = "top";
        height = 40;
        spacing = 3;
        margin-top = 2;
        margin-right = 5;
        margin-bottom = 1;
        margin-left = 5;

        "group/users" = {
          orientation = "horizontal";
          modules = [
            "user"
            "custom/power"
          ];
          drawer.transition-left-to-right = true;
        };

        user = {
          height = 22;
          width = 22;
        };

        "hyprland/submap" = {
          always-on = false;
          tooltip = false;
          format = " {}";
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
            icon-theme = theme.icons.name;
            on-click-window = "hyprutils click {button} {address}";
            ignore-list = [
              "kitty-clip"
              "kitty-dropterm"
            ];
          };
        };

        "custom/minimized" = {
          format = "";
          on-click = "hyprutils toggle minimized";
        };

        "group/menu" = {
          orientation = "horizontal";
          drawer.transition-left-to-right = true;
        };

        "group/media" = {
          orientation = "horizontal";
          drawer.transition-left-to-right = false;
        };

        "group/display" = {
          orientation = "horizontal";
          drawer.transition-left-to-right = false;
        };

        backlight.on-click = "nwg-displays";

        "group/power" = {
          orientation = "horizontal";
          drawer.transition-left-to-right = false;
        };

        battery = {
          align = 0;
          on-click-right = "hyprutils toggle fancy";
        };

        "group/notify" = {
          orientation = "horizontal";
          drawer.transition-left-to-right = false;
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
        panel
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
        panel
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
    ];
  };
}

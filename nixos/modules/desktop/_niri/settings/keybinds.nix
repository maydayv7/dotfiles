_: {config, ...}: let
  inherit
    (builtins)
    concatLists
    genList
    listToAttrs
    toString
    ;
in {
  programs.niri.settings = {
    input.power-key-handling.enable = false;
    binds = with config.lib.niri.actions; let
      sh = spawn "sh" "-c";
    in
      {
        # Compositor
        "Super+slash".action = show-hotkey-overlay;
        "Super+Q".action = close-window;
        "Super+C".action = center-window;
        "Super+Shift+F".action = fullscreen-window;
        "Super+equal".action = switch-preset-column-width;
        "Super+minus".action = switch-preset-window-height;
        "Super+Shift+equal".action = maximize-column;
        "Super+Shift+minus".action = set-column-width "+10%";
        "Super+semicolon".action = toggle-window-floating;
        "Super+apostrophe".action = switch-focus-between-floating-and-tiling;
        "Super+Shift+Tab".action = toggle-column-tabbed-display;

        "Super+Tab".action = toggle-overview;
        "Super+Right".action = focus-column-or-monitor-right;
        "Super+Left".action = focus-column-or-monitor-left;
        "Super+Up".action = focus-window-or-workspace-up;
        "Super+Down".action = focus-window-or-workspace-down;

        "Super+Shift+Right".action = consume-or-expel-window-right;
        "Super+Shift+Left".action = consume-or-expel-window-left;
        "Super+Shift+Up".action = move-window-up-or-to-workspace-up;
        "Super+Shift+Down".action = move-window-down-or-to-workspace-down;
        "Super+Shift+Return".action = move-window-to-monitor-next;

        "Print".action.screenshot = [];
        "Shift+Print".action.screenshot-screen = [];
        "Ctrl+Print".action.screenshot-window = [];

        # Controls
        "Super+L" = {
          action = sh "loginctl lock-session";
          hotkey-overlay.title = "Lock Screen";
        };

        "XF86AudioPlay".action = sh "sysutils media toggle";
        "XF86AudioPrev".action = sh "sysutils media previous";
        "XF86AudioNext".action = sh "sysutils media next";
        "XF86AudioMute".action = sh "sysutils volume mute";
        "XF86AudioRaiseVolume".action = sh "sysutils volume up";
        "XF86AudioLowerVolume".action = sh "sysutils volume down";
        "XF86MonBrightnessUp".action = sh "sysutils brightness up";
        "XF86MonBrightnessDown".action = sh "sysutils brightness down";
        "XF86KbdBrightnessUp".action = sh "sysutils backlight up";
        "XF86KbdBrightnessDown".action = sh "sysutils backlight down";

        # Mouse
        "Super+Shift+MouseRight".action = switch-preset-window-width;
        "Super+WheelScrollUp" = {
          action = focus-workspace-up;
          cooldown-ms = 150;
        };
        "Super+WheelScrollDown" = {
          action = focus-workspace-down;
          cooldown-ms = 150;
        };
      }
      //
      # Workspaces
      listToAttrs (
        concatLists (
          genList (
            n: let
              num = n + 1;
              snum = toString (n + 1);
            in [
              {
                name = "Super+${snum}";
                value.action = focus-workspace num;
              }
              {
                name = "Super+Shift+${snum}";
                value.action.move-window-to-workspace = num;
              }
            ]
          )
          9
        )
      );
  };
}

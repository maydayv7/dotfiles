## Compositor Binds
_: {config, ...}: {
  programs.niri.settings = {
    input.power-key-handling.enable = false;
    binds = with config.lib.niri.actions; let
      sh = spawn "sh" "-c";
    in
      {
        # Compositor
        "Super+slash".action = show-hotkey-overlay;
        "Alt+F4".action = close-window;
        "Super+Q".action = close-window;
        "Super+C".action = center-window;
        "Super+E".action = maximize-window-to-edges;
        "Super+Shift+E".action = fullscreen-window;
        "Super+bracketright".action = set-column-width "+10%";
        "Super+bracketleft".action = switch-preset-column-width;
        "Super+equal".action = maximize-column;
        "Super+minus".action = switch-preset-window-height;
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

        # Screenshots
        "Print".action = sh "noctalia msg screenshot-region";
        "Shift+Print".action = sh "noctalia msg screenshot-fullscreen pick";
        "Ctrl+Print".action.screenshot-window = [];

        # Controls
        "Super+L" = {
          action = sh "noctalia msg session lock";
          hotkey-overlay.title = "Lock Screen";
        };

        "XF86AudioPlay".action = sh "noctalia msg media toggle";
        "XF86AudioPrev".action = sh "noctalia msg media previous";
        "XF86AudioNext".action = sh "noctalia msg media next";
        "XF86AudioMute".action = sh "noctalia msg volume-mute";
        "XF86AudioRaiseVolume".action = sh "noctalia msg volume-up";
        "XF86AudioLowerVolume".action = sh "noctalia msg volume-down";
        "XF86MonBrightnessUp".action = sh "noctalia msg brightness-up";
        "XF86MonBrightnessDown".action = sh "noctalia msg brightness-down";
        "XF86KbdBrightnessUp".action = sh "noctalia msg kbd-brightness-up";
        "XF86KbdBrightnessDown".action = sh "noctalia msg kbd-brightness-down";

        # Mouse
        "Super+Shift+MouseRight".action = switch-preset-window-width;
        "Super+WheelScrollUp" = {
          action = focus-column-left;
          cooldown-ms = 150;
        };
        "Super+WheelScrollDown" = {
          action = focus-column-right;
          cooldown-ms = 150;
        };
        "Super+Shift+WheelScrollUp" = {
          action = focus-workspace-up;
          cooldown-ms = 150;
        };
        "Super+Shift+WheelScrollDown" = {
          action = focus-workspace-down;
          cooldown-ms = 150;
        };
      }
      //
      # Workspaces
      builtins.listToAttrs (
        builtins.concatLists (
          builtins.genList (
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

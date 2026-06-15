## Compositor Binds
_: _: let
  inherit (builtins) concatLists genList toString;
in {
  wayland.windowManager.hyprland = {
    ## Keybindings
    settings = {
      "$mod" = "SUPER";
      bind =
        [
          # Compositor Commands
          "ALT, F4, killactive,"
          "$mod, Q, killactive,"
          "$mod SHIFT, Q, forcekillactive,"
          "$mod SHIFT, E, fullscreen,"
          "$mod, C, centerwindow"
          "$mod, C, movecursortocorner, 2"
          "$mod, E, fullscreen, 1"
          "$mod, P, pin"
          "$mod, Space, layoutmsg, togglesplit"
          "$mod SHIFT, S, toggleswallow"

          # Window Focus
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
          "ALT, A, focusurgentorlast"
          "ALT, A, alterzorder, top"

          # Window Swap
          "$mod SHIFT, left, swapwindow, l"
          "$mod SHIFT, right, swapwindow, r"
          "$mod SHIFT, up, swapwindow, u"
          "$mod SHIFT, down, swapwindow, d"

          # Window Groups
          "$mod SHIFT, space, togglegroup"
          "ALT, grave, changegroupactive, f"
          "ALT SHIFT, grave, changegroupactive, b"
          "$mod CTRL, left, moveintogroup, l"
          "$mod CTRL, right, moveintogroup, r"
          "$mod CTRL, up, moveintogroup, u"
          "$mod CTRL, down, moveintogroup, d"

          # Floating Mode
          "$mod, semicolon, togglefloating,"
          "$mod, apostrophe, exec, hyprutils toggle float"

          # Cycle Workspaces
          "$mod, comma, split-cycleworkspaces, prev"
          "$mod, period, split-cycleworkspaces, next"
          "$mod CTRL, comma, split-cycleworkspaces, prev"
          "$mod CTRL, period, split-cycleworkspaces, next"
          "$mod, mouse_up, split-cycleworkspaces, prev"
          "$mod, mouse_down, split-cycleworkspaces, next"

          # Special Workspace
          "$mod, 0, togglespecialworkspace, Stash"
          "$mod SHIFT, 0, exec, pypr toggle_special Stash"

          # Move Window to Workspace
          "$mod SHIFT, comma, split-movetoworkspace, -1"
          "$mod SHIFT, period, split-movetoworkspace, +1"

          # Cycle Monitors
          "$mod ALT, comma, focusmonitor, l"
          "$mod ALT, period, focusmonitor, r"

          # Move Window to Monitor
          "$mod SHIFT ALT, comma, movewindow, mon:-1"
          "$mod SHIFT ALT, period, movewindow, mon:+1"

          # Screen Lock
          "$mod, L, exec, loginctl lock-session"

          # Window Minimization
          "ALT, Q, movetoworkspacesilent, special:minimized"
          "ALT SHIFT, Q, exec, hyprutils toggle minimized"

          # Screenshot
          '', Print, exec, sh -c "pgrep slurp || grimblast --notify --freeze copysave area"''
          "CTRL, Print, exec, grimblast --notify --cursor copysave active"
          "SHIFT, Print, exec, grimblast --notify --cursor copysave output"

          # Submaps
          "$mod SHIFT, Escape, exec, sysutils toggle service waycorner"
          "$mod SHIFT, Escape, submap, Inhibit"
          "$mod, R, submap, Resize"
          "$mod, M, submap, Move"
        ]
        ++
        # Workspaces
        (concatLists (
          genList (
            n: let
              num = toString (n + 1);
            in [
              "$mod, ${num}, split-workspace, ${num}"
              "$mod SHIFT, ${num}, split-movetoworkspace, ${num}"
            ]
          )
          9
        ));

      # Mouse
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Ignore Locked State
      bindl = [
        # Media Controls
        ", XF86AudioPlay, exec, sysutils media toggle"
        ", XF86AudioPrev, exec, sysutils media previous"
        ", XF86AudioNext, exec, sysutils media next"

        # Volume
        ", XF86AudioMute, exec, sysutils volume mute"

        # Keyboard Backlight
        ", XF86KbdBrightnessUp, exec, sysutils backlight up"
        ", XF86KbdBrightnessDown, exec, sysutils backlight down"

        # Touchpad
        ", XF86TouchpadToggle, exec, hyprutils toggle touchpad"
      ];

      # Repeat on Hold
      bindle = [
        # Volume
        ", XF86AudioRaiseVolume, exec, sysutils volume up"
        ", XF86AudioLowerVolume, exec, sysutils volume down"

        # Backlight
        ", XF86MonBrightnessUp, exec, sysutils brightness up"
        ", XF86MonBrightnessDown, exec, sysutils brightness down"

        # Magnifier
        "$mod, equal, exec, pypr zoom ++0.5"
        "$mod, minus, exec, pypr zoom --0.5"
        "$mod SHIFT, minus, exec, pypr zoom"
      ];
    };

    ## Submaps
    submaps = {
      # Inhibit Keybinds
      Inhibit.settings.bind = [
        "$mod SHIFT, Escape, exec, sysutils toggle service waycorner"
        "$mod SHIFT, Escape, submap, reset"
      ];

      # Window Resize
      Resize.settings = {
        binde = [
          ", right, resizeactive, 10 0"
          ", left, resizeactive, -10 0"
          ", up, resizeactive, 0 -10"
          ", down, resizeactive, 0 10"
        ];
        bindm = [", mouse:272, resizewindow"];
        bind = [
          ", escape, submap, reset"
          "$mod, R, submap, reset"
        ];
      };

      # Window Movement
      Move.settings = {
        bind = [
          ", C, centerwindow"
          ", P, pin"
          ", left, movewindoworgroup, l"
          ", right, movewindoworgroup, r"
          ", up, movewindoworgroup, u"
          ", down, movewindoworgroup, d"
          "SHIFT, left, moveactive, -30 0"
          "SHIFT, right, moveactive, 30 0"
          "SHIFT, up, moveactive, 0 -30"
          "SHIFT, down, moveactive, 0 30"
          ", comma, split-movetoworkspace, -1"
          ", period, split-movetoworkspace, +1"
          ", escape, submap, reset"
          "$mod, M, submap, reset"
        ];
        bindm = [", mouse:272, movewindow"];
      };

      # Window Minimization
      Minimized.settings.bind = [
        ", left, movefocus, l"
        ", right, movefocus, r"
        ", up, movefocus, u"
        ", down, movefocus, d"
        ", Q, killactive,"
        ", Return, movetoworkspace, +0"
        ", Return, submap, reset"
        ", mouse:272, movetoworkspace, +0"
        ", mouse:272, submap, reset"
        ", escape, togglespecialworkspace, minimized"
        ", escape, submap, reset"
      ];
    };
  };
}

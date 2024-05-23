{sys, ...}: {
  ## Compositor Binds ##
  wayland.windowManager.hyprland = {
    ## Keybindings
    settings = {
      "$mod" = "SUPER";
      bind =
        [
          # Compositor Commands
          "$mod, Q, killactive,"
          "ALT, F4, killactive,"
          "$mod, P, pin"
          "$mod, E, fullscreen, 1"
          "$mod SHIFT, E, fullscreen,"
          "$mod, Space, togglesplit"
          "$mod SHIFT, D, exec, hyprutils toggle monitor ${sys.gui.display}"

          # Window Focus
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
          "ALT, A, focusurgentorlast"
          "ALT, A, bringactivetotop,"

          # Window Swap
          "$mod SHIFT, left, swapwindow, l"
          "$mod SHIFT, right, swapwindow, r"
          "$mod SHIFT, up, swapwindow, u"
          "$mod SHIFT, down, swapwindow, d"

          # Window Groups
          "$mod SHIFT, space, togglegroup"
          "ALT, grave, changegroupactive, f"
          "ALT SHIFT, grave, changegroupactive, b"

          # Floating Mode
          "$mod, semicolon, togglefloating,"
          "$mod, apostrophe, exec, hyprutils toggle float"
          "$mod, C, centerwindow"

          # Window Minimization
          "ALT, Q, movetoworkspacesilent, special:minimized"
          "ALT SHIFT, Q, togglespecialworkspace, minimized"

          # Cycle Workspaces
          "$mod, comma, split:workspace, m-1"
          "$mod, period, split:workspace, m+1"

          # Special Workspace
          "$mod, 0, togglespecialworkspace, stash"
          "$mod SHIFT, 0, exec, pypr toggle_special stash"

          # Move Window to Workspace
          "$mod SHIFT, comma, split:movetoworkspace, r-1"
          "$mod SHIFT, period, split:movetoworkspace, r+1"

          # Cycle Monitors
          "$mod ALT, comma, focusmonitor, l"
          "$mod ALT, period, focusmonitor, r"

          # Move Window to Monitor
          "$mod SHIFT ALT, comma, movewindow, mon:-1"
          "$mod SHIFT ALT, period, movewindow, mon:+1"

          # Screen Lock
          "$mod, L, exec, loginctl lock-session"

          # Screenshot
          ", Print, exec, grimblast --notify --freeze copysave area"
          "CTRL, Print, exec, grimblast --notify --cursor copysave active"
          "SHIFT, Print, exec, grimblast --notify --cursor copysave output"
        ]
        ++
        # Workspaces
        (with builtins;
          concatLists (genList (
              n: let
                num = toString (n + 1);
              in [
                "$mod, ${num}, split:workspace, ${num}"
                "$mod SHIFT, ${num}, split:movetoworkspace, ${num}"
              ]
            )
            9));

      # Mouse
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod SHIFT, mouse:272, moveintogroup"
      ];

      # Ignore Locked State
      bindl = [
        # Media Controls
        ", XF86AudioPlay, exec, hyprutils media toggle"
        ", XF86AudioPrev, exec, hyprutils media previous"
        ", XF86AudioNext, exec, hyprutils media next"

        # Volume
        ", XF86AudioMute, exec, hyprutils volume mute"
      ];

      # Repeat on Hold
      bindle = [
        # Volume
        ", XF86AudioRaiseVolume, exec, hyprutils volume up"
        ", XF86AudioLowerVolume, exec, hyprutils volume down"

        # Backlight
        ", XF86MonBrightnessUp, exec, hyprutils brightness up"
        ", XF86MonBrightnessDown, exec, hyprutils brightness down"

        # Magnifier
        "$mod, equal, exec, hyprutils zoom in"
        "$mod, minus, exec, hyprutils zoom out"
      ];
    };

    ## Submaps
    extraConfig = ''
      # Window Resize
      bind = $mod, R, submap, Resize
      submap = Resize
      binde = , right, resizeactive, 10 0
      binde = , left, resizeactive, -10 0
      binde = , up, resizeactive, 0 -10
      binde = , down, resizeactive, 0 10
      bindm = , mouse:272, resizewindow
      bind = , escape, submap, reset
      submap = reset

      # Window Movement
      bind = $mod, M, submap, Move
      submap = Move
      bindm = , mouse:272, movewindow
      bind = , C, centerwindow
      bind = , P, pin
      bind = , left, movewindoworgroup, l
      bind = , right, movewindoworgroup, r
      bind = , up, movewindoworgroup, u
      bind = , down, movewindoworgroup, d
      bind = SHIFT, left, moveactive, -30 0
      bind = SHIFT, right, moveactive, 30 0
      bind = SHIFT, up, moveactive, 0 -30
      bind = SHIFT, down, moveactive, 0 30
      bind = , escape, submap, reset
      submap = reset

      # Window Minimization
      bind = ALT SHIFT, Q, submap, Minimized
      submap = Minimized
      bind = , F4, killactive
      bind = , left, movefocus, l
      bind = , right, movefocus, r
      bind = , up, movefocus, u
      bind = , down, movefocus, d
      bind = , Return, movetoworkspace, +0
      bind = , Return, submap, reset
      bind = , mouse:272, movetoworkspace, +0
      bind = , mouse:272, submap, reset
      bind = , escape, togglespecialworkspace, minimized
      bind = , escape, submap, reset
      submap = reset
    '';
  };
}

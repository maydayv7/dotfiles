_: {
  ## Keybindings
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    bind =
      [
        # Compositor Commands
        "$mod, Q, killactive,"
        "$mod, M, fullscreen, 1"
        "$mod SHIFT, M, fullscreen,"

        # Focus Change
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Window Swap
        "$mod SHIFT, left, swapwindow, l"
        "$mod SHIFT, right, swapwindow, r"
        "$mod SHIFT, up, swapwindow, u"
        "$mod SHIFT, down, swapwindow, d"

        # Tiling
        "$mod, Space, togglesplit"
        "$mod SHIFT, Space, togglegroup"
        "$mod, Tab, changegroupactive, f"
        "$mod SHIFT, Tab, changegroupactive, b"

        # Floating Mode
        "$mod, O, togglefloating,"
        "$mod, P, workspaceopt, allfloat"
        "$mod, C, centerwindow"

        # Window Switcher
        "ALT, Tab, cyclenext,"
        "ALT, Tab, bringactivetotop,"
        "ALT CTRL, Tab, cyclenext, prev"
        "ALT CTRL, Tab, bringactivetotop,"

        # Overview
        "ALT, grave, hycov:toggleoverview"
        "ALT SHIFT, grave, hycov:toggleoverview, forceall"
        "ALT, left, hycov:movefocus, l"
        "ALT, right, hycov:movefocus, r"
        "ALT, up, hycov:movefocus, u"
        "ALT, down, hycov:movefocus, d"

        # Window Minimize
        "ALT, Q, hych:minimize"
        "ALT SHIFT, Q, hych:toggle_restore_window"

        # Cycle Workspaces
        "$mod, period, workspace, m-1"
        "$mod, comma, workspace, m+1"

        # Special Workspace
        "$mod SHIFT, grave, movetoworkspace, special"
        "$mod, grave, togglespecialworkspace, eDP-1"

        # Move Window to Workspace
        "$mod SHIFT, period, movetoworkspace, m-1"
        "$mod SHIFT, comma, movetoworkspace, m+1"

        # Cycle Monitors
        "$mod SHIFT, period, focusmonitor, l"
        "$mod SHIFT, comma, focusmonitor, r"

        # Send Focused Workspace to Monitor
        "$mod SHIFT CTRL, period, movecurrentworkspacetomonitor, l"
        "$mod SHIFT CTRL, comma, movecurrentworkspacetomonitor, r"

        # Screen Lock
        "$mod, L, exec, loginctl lock-session"

        # Screenshot
        ", Print, exec, grimblast --notify copysave area"
        "CTRL, Print, exec, grimblast --notify --cursor copysave output"
        "SHIFT, Print, exec, grimblast --notify --cursor copysave screen"

        # Magnifier
        ''$mod, equal, exec, hyprctl keyword misc:cursor_zoom_factor "$(hyprctl getoption misc:cursor_zoom_factor | grep float | awk '{print $2 + 1}')"''
        ''$mod, minus, exec, hyprctl keyword misc:cursor_zoom_factor "$(hyprctl getoption misc:cursor_zoom_factor | grep float | awk '{print $2 - 1}')"''
      ]
      ++
      # Workspaces
      (with builtins;
        concatLists (genList (
            num: let
              key = toString (num + 1 - (((num + 1) / 10) * 10));
              workspace = toString (num + 1);
            in [
              "$mod, ${key}, workspace, ${workspace}"
              "$mod SHIFT, ${key}, movetoworkspace, ${workspace}"
            ]
          )
          10));

    # Mouse
    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
      "$mod CTRL, mouse:272, resizewindow"
      "$mod SHIFT, mouse:272, moveintogroup"
    ];

    # Ignore Locked State
    bindl = [
      # Media Controls
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86AudioNext, exec, playerctl next"

      # Volume
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    ];

    # Repeat on Hold
    bindle = [
      # Volume
      ", XF86AudioRaiseVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 5%-"

      # Backlight
      ", XF86MonBrightnessUp, exec, brillo -u 300000 -A 5"
      ", XF86MonBrightnessDown, exec, brillo -u 300000 -U 5"
    ];
  };
}

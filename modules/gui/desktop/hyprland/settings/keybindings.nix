_: {
  ## Compositor Keybindings
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    bind =
      [
        # Compositor Commands
        "$mod, Q, killactive,"
        "$mod, P, pin"
        "$mod, M, fullscreen, 1"
        "$mod SHIFT, M, fullscreen,"
        "$mod, Space, togglesplit"

        # Window Focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "ALT CTRL, Tab, focusurgentorlast"
        "ALT CTRL, Tab, bringactivetotop,"

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
        "$mod, apostrophe, workspaceopt, allfloat"
        "$mod, C, centerwindow"

        # Cycle Workspaces
        "$mod, comma, workspace, m-1"
        "$mod, period, workspace, m+1"

        # Special Workspace
        "$mod, grave, togglespecialworkspace, stash"
        "$mod SHIFT, grave, exec, pypr toggle_special stash"

        # Move Window to Workspace
        "$mod SHIFT, comma, movetoworkspace, r-1"
        "$mod SHIFT, period, movetoworkspace, r+1"

        # Cycle Monitors
        "$mod ALT, comma, focusmonitor, l"
        "$mod ALT, period, focusmonitor, r"

        # Send Focused Workspace to Monitor
        "$mod SHIFT ALT, comma, movecurrentworkspacetomonitor, l"
        "$mod SHIFT ALT, period, movecurrentworkspacetomonitor, r"

        # Screen Lock
        "$mod, L, exec, loginctl lock-session"

        # Screenshot
        ", Print, exec, grimblast --notify copysave area"
        "CTRL, Print, exec, grimblast --notify --cursor copysave output"
        "SHIFT, Print, exec, grimblast --notify --cursor copysave screen"

        # Magnifier
        ''$mod, equal, exec, pypr zoom "$(hyprctl getoption misc:cursor_zoom_factor | grep float | awk '{print $2 + 1}')"''
        ''$mod, minus, exec, pypr zoom "$(hyprctl getoption misc:cursor_zoom_factor | grep float | awk '{print $2 - 1}')"''
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
      ", XF86AudioPlay, exec, hyprutils play_pause"
      ", XF86AudioPrev, exec, hyprutils prev_track"
      ", XF86AudioNext, exec, hyprutils next_track"

      # Volume
      ", XF86AudioMute, exec, hyprutils volume_mute"
    ];

    # Repeat on Hold
    bindle = [
      # Volume
      ", XF86AudioRaiseVolume, exec, hyprutils volume_up"
      ", XF86AudioLowerVolume, exec, hyprutils volume_down"

      # Backlight
      ", XF86MonBrightnessUp, exec, hyprutils brightness_up"
      ", XF86MonBrightnessDown, exec, hyprutils brightness_down"
    ];
  };
}

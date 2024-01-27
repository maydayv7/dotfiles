_: {
  ## Keybindings
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    bind =
      [
        # Apps
        "$mod, F, exec, thunar"
        "$mod, T, exec, kitty"
        "$mod, W, exec, firefox"
        "$mod, Return, exec, missioncenter"
        "$mod, slash, exec, ulauncher-toggle"

        # Compositor Commands
        "$mod, Q, killactive,"
        "$mod, grave, fullscreen, 1"
        "$mod SHIFT, grave, fullscreen,"
        "$mod, O, togglefloating,"
        "$mod, P, workspaceopt, allfloat" # Floating Mode

        # Focus Change
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Window Switcher
        "ALT, Tab, cyclenext,"
        "ALT, Tab, bringactivetotop,"
        "ALT CTRL, Tab, cyclenext, prev"
        "ALT CTRL, Tab, bringactivetotop,"

        # Cycle Workspaces
        "$mod, period, workspace, m-1"
        "$mod, comma, workspace, m+1"

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
      ", XF86AudioRaiseVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%-"

      # Backlight
      ", XF86MonBrightnessUp, exec, brillo -q -u 300000 -A 5"
      ", XF86MonBrightnessDown, exec, brillo -q -u 300000 -U 5"
    ];
  };
}

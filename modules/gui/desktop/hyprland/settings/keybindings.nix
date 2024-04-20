{sys, ...}: {
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
        "$mod SHIFT, D, exec, hyprutils toggle monitor ${sys.gui.display}"

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
        "$mod, apostrophe, exec, hyprutils toggle float"
        "$mod, C, centerwindow"

        # Window Minimization
        "ALT, Q, movetoworkspacesilent, special:minimized"
        "ALT SHIFT, Q, togglespecialworkspace, minimized"
        "ALT SHIFT, Q, movetoworkspace, +0"

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
      ]
      ++
      # Workspaces
      (with builtins;
        concatLists (genList (
            n: let
              num = toString (n + 1);
            in [
              "$mod, ${num}, workspace, ${num}"
              "$mod SHIFT, ${num}, movetoworkspace, ${num}"
            ]
          )
          9));

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
}

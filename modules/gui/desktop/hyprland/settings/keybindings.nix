{
  sys,
  pkgs,
  files,
  ...
}: let
  inherit (sys.lib.stylix.colors) base07 base0D;
  utils = "${pkgs.writeShellApplication {
    name = "utils";
    text = builtins.replaceStrings ["#ffffff"] ["#${base07}"] files.scripts.utils;
    runtimeInputs = with pkgs; [coreutils alsa-utils brillo playerctl libnotify wget];
  }}/bin/utils";
in {
  ## Keybindings
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    env = ["SLURP_ARGS, -dc ${base0D}"]; # Screengrab
    bind =
      [
        ("$mod SHIFT, slash, exec, xdg-open " + ../README.md)

        # Compositor Commands
        "$mod, Q, killactive,"
        "$mod, P, pin"
        "$mod, M, fullscreen, 1"
        "$mod SHIFT, M, fullscreen,"
        "$mod, U, focusurgentorlast"
        "$mod, U, bringactivetotop,"

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
        "$mod, semicolon, togglefloating,"
        "$mod, apostrophe, workspaceopt, allfloat"
        "$mod, C, centerwindow"

        # Window Switcher
        "ALT, Tab, cyclenext,"
        "ALT, Tab, bringactivetotop,"
        "ALT CTRL, Tab, cyclenext, prev"
        "ALT CTRL, Tab, bringactivetotop,"

        # Cycle Workspaces
        "$mod, comma, workspace, m-1"
        "$mod, period, workspace, m+1"

        # Special Workspace
        "$mod SHIFT, grave, movetoworkspace, special"
        "$mod, grave, togglespecialworkspace, ${sys.gui.display}"

        # Move Window to Workspace
        "$mod SHIFT, comma, movetoworkspace, m-1"
        "$mod SHIFT, period, movetoworkspace, m+1"

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
      ", XF86AudioPlay, exec, ${utils} play_pause"
      ", XF86AudioPrev, exec, ${utils} prev_track"
      ", XF86AudioNext, exec, ${utils} next_track"

      # Volume
      ", XF86AudioMute, exec, ${utils} volume_mute"
    ];

    # Repeat on Hold
    bindle = [
      # Volume
      ", XF86AudioRaiseVolume, exec, ${utils} volume_up"
      ", XF86AudioLowerVolume, exec, ${utils} volume_down"

      # Backlight
      ", XF86MonBrightnessUp, exec, ${utils} brightness_up"
      ", XF86MonBrightnessDown, exec, ${utils} brightness_down"
    ];
  };
}

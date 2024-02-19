{pkgs, ...}: {
  ## Plugin Settings
  wayland.windowManager.hyprland = {
    plugins = with pkgs.hyprworld; [hych hycov];
    extraConfig = ''
      plugin {
        # Window Minimize
        hych {
          enable_alt_release_exit = 1
          alt_replace_key = code:64
        }

        # Overview
        hycov {
          enable_hotarea = 1
          hotarea_pos = 3
          only_active_workspace = 1
          overview_gappi = 24
          overview_gappo = 60
          enable_gesture = 1
          swipe_fingers = 4
          enable_alt_release_exit = 1
          alt_replace_key = Alt_L
          alt_toggle_auto_next = 1
        }
      }
    '';

    settings.bind = [
      # Window Minimize
      "ALT, Q, hych:minimize"
      "ALT SHIFT, Q, hych:toggle_restore_window"

      # Overview
      "ALT, grave, hycov:toggleoverview"
      "ALT SHIFT, grave, hycov:toggleoverview, forceall"
      "ALT, left, hycov:movefocus, l"
      "ALT, right, hycov:movefocus, r"
      "ALT, up, hycov:movefocus, u"
      "ALT, down, hycov:movefocus, d"
    ];
  };
}

{
  sys,
  lib,
  util,
  ...
}: {
  ## Hyprland Settings
  imports = util.map.modules.list ./.;
  stylix.targets.hyprland.enable = true;
  dconf.settings."org/gnome/desktop/wm/preferences".button-layout = "appmenu";
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      debug.disable_logs = false;
      env = ["QT_WAYLAND_DISABLE_WINDOWDECORATION,1"];

      # Display
      monitor = ",preferred,auto,1";
      xwayland.force_zero_scaling = true;

      input = {
        # Keyboard
        kb_layout = "us";
        numlock_by_default = true;

        # Mouse
        follow_mouse = 1; # Focus on cursor move
        accel_profile = "flat";
        touchpad = {
          disable_while_typing = true;
          natural_scroll = true;
          tap-to-click = true;
          tap-and-drag = true;
        };
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
        workspace_swipe_forever = true;
      };

      # Tiling Layout
      dwindle = {
        pseudotile = true; # Keep floating dimensions
        preserve_split = true;
      };

      misc = {
        enable_swallow = true;

        # Interfere with wallpaper daemons
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;

        # Prevent checking for configuration changes
        # Use 'hyprctl reload' if required
        disable_autoreload = true;

        # Graphics
        vrr = 1;
        no_direct_scanout = false;
      };

      general =
        {
          resize_on_border = true;
          allow_tearing = !sys.gui.fancy;
        }
        //
        # Visuals
        {
          gaps_in = 5;
          gaps_out = 5;
          border_size = 2;
        };

      decoration = lib.mkIf sys.gui.fancy {
        rounding = 10;
        drop_shadow = true;
        shadow_ignore_window = true;
        shadow_offset = "0 2";
        shadow_range = 20;
        dim_special = 0.3;

        blur = {
          enabled = true;
          brightness = 1.0;
          contrast = 1.0;
          passes = 2;
        };
      };
    };
  };
}

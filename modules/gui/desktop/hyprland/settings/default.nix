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
    inherit (sys.programs.hyprland) enable package;

    # Use 'nwg-displays' to configure monitors
    extraConfig = ''
      source = ~/.config/hypr/monitors.conf
      source = ~/.config/hypr/workspaces.conf
    '';

    settings = {
      debug.disable_logs = false;
      env = ["QT_WAYLAND_DISABLE_WINDOWDECORATION,1"];
      exec-once = ["dbus-update-activation-environment --systemd --all"];

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
        workspace_swipe_numbered = true;
      };

      # Tiling Layout
      dwindle = {
        pseudotile = true; # Keep floating dimensions
        preserve_split = true;
      };

      misc = {
        disable_autoreload = false;

        # Window Swallowing
        enable_swallow = true;

        # Interfere with wallpaper daemons
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;

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

      group.groupbar = with sys.lib.stylix.colors; {
        enabled = true;
        render_titles = false;
        height = 7;
        scrolling = true;
        "col.active" = "rgb(${base0A})";
        "col.locked_active" = "rgb(${base0D})";
      };

      animation = {
        bezier = [
          "fluentish, 0, 0.2, 0.4, 1"
          "easeOutCircle, 0, 0.55, 0.45, 1"
          "easeOutCubic, 0.33, 1, 0.68, 1"
          "easeInOutSine, 0.37, 0, 0.63, 1"
        ];

        animation = [
          "windowsIn, 1, 1.7, easeOutCubic, slide"
          "windowsOut, 1, 1.7, easeOutCubic, slide"
          "windowsMove, 1, 2.5, easeInOutSine, slide"

          # Fading
          "fadeIn, 1, 3, easeOutCubic"
          "fadeOut, 1, 3, easeOutCubic"
          "fadeSwitch, 1, 5, easeOutCircle"
          "fadeShadow, 1, 5, easeOutCircle"
          "fadeDim, 1, 6, fluentish"
          "border, 1, 2.7, easeOutCircle"
          "workspaces, 1, 2, fluentish, slide"
          "specialWorkspace, 1, 3, fluentish, slidevert"
        ];
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

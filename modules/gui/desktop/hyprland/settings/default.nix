{
  sys,
  lib,
  util,
  ...
}: let
  inherit (lib) mkForce mkIf;
  inherit (sys.gui) fancy;
  inherit (sys.lib.stylix.colors) base03 base0A base0D;
in {
  ## Hyprland Settings
  imports = util.map.modules.list ./.;
  stylix.targets.hyprland.enable = true;
  wayland.windowManager.hyprland = {
    inherit (sys.programs.hyprland) enable package;

    # Use 'nwg-displays' to configure monitors
    extraConfig = ''
      source = ~/.config/hypr/monitors.conf
      source = ~/.config/hypr/workspaces.conf
    '';

    settings = {
      debug.disable_logs = false;

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

      # Workspace Behaviour
      binds = {
        workspace_center_on = 1;
        movefocus_cycles_fullscreen = true;
        workspace_back_and_forth = true;
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
        workspace_swipe_forever = true;
        workspace_swipe_use_r = true;
        workspace_swipe_create_new = true;
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
        hide_cursor_on_key_press = true;
      };

      general =
        {
          resize_on_border = true;
          allow_tearing = !fancy;
        }
        //
        # Visuals
        {
          gaps_in = 5;
          gaps_out = 5;
          border_size = 2;
          "col.active_border" = mkForce "rgb(${base0D}) rgb(${base0A}) 90deg";
        };

      group = let
        active = "rgb(${base0A}) rgb(${base0D}) 90deg";
        inactive = "rgb(${base03}) rgb(${base0D}) 90deg";
      in {
        groupbar = {
          enabled = true;
          render_titles = false;
          height = 7;
          scrolling = true;
          gradients = true;
          "col.active" = active;
          "col.locked_active" = active;
          "col.inactive" = inactive;
          "col.locked_inactive" = inactive;
        };
        "col.border_active" = mkForce active;
        "col.border_locked_active" = mkForce active;
        "col.border_inactive" = mkForce inactive;
        "col.border_locked_inactive" = mkForce inactive;
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

      decoration = mkIf fancy {
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

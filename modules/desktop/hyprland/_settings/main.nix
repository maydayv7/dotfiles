## Compositor Settings
_: {
  lib,
  osConfig ? null,
  ...
}:
lib.mkIf (osConfig != null) (
  let
    inherit (lib) mkForce mkIf;
    inherit (osConfig.gui) display fancy;
    inherit (osConfig.lib.stylix.colors) base03 base05 base0D;
  in {
    stylix.targets.hyprland.enable = true;
    wayland.windowManager.hyprland = {
      inherit (osConfig.programs.hyprland) enable package portalPackage;

      # ! # TODO
      configType = "hyprlang";

      # Use 'nwg-displays' to configure monitors
      extraConfig = ''
        source = ~/.config/hypr/monitors.conf
        source = ~/.config/hypr/workspaces.conf
      '';

      settings = {
        # Display
        monitor = ", preferred, auto, 1";
        xwayland = {
          enabled = true;
          force_zero_scaling = true;
        };

        input = {
          follow_mouse = 1; # Focus on cursor move
          follow_mouse_threshold = 15;
          focus_on_close = 1;

          # Keyboard
          kb_layout = "us";
          numlock_by_default = true;

          # Mouse
          accel_profile = "flat";
          touchpad = {
            tap-to-click = true;
            tap-and-drag = true;
            natural_scroll = true;
            disable_while_typing = false;
            drag_3fg = 1; # 3-finger window drag
          };
        };

        # Workspace Behaviour
        binds = {
          workspace_center_on = 1;
          movefocus_cycles_fullscreen = true;
          workspace_back_and_forth = true;
          drag_threshold = 30;
        };

        gesture = [
          "3, horizontal, workspace"
        ];

        # Touchpad Gestures
        gestures = {
          workspace_swipe_use_r = false;
          workspace_swipe_create_new = true;
        };

        # Cursor Settings
        cursor = {
          default_monitor = display;
          hide_on_key_press = true;
          sync_gsettings_theme = true;
          warp_on_change_workspace = true;
        };

        # Tiling Layout
        dwindle = {
          preserve_split = true;
          smart_split = true;
        };

        # Smart Gaps
        workspace = [
          "w[tv1]s[false], gapsout:0, gapsin:0"
          "f[1]s[false], gapsout:0, gapsin:0"
        ];
        windowrule = [
          "border_size 0, rounding 0, match:float 0, match:workspace w[tv1]s[false]"
          "border_size 0, rounding 0, match:float 0, match:workspace f[1]s[false]"
        ];

        misc = {
          disable_autoreload = true; # Disable configuration Polling
          enable_swallow = true; # Window Swallowing

          focus_on_activate = true;
          initial_workspace_tracking = 1;
          middle_click_paste = false;
          on_focus_under_fullscreen = 2;

          # Interfere with wallpaper daemons
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;

          # Graphics
          vrr = 1;
        };
        render.direct_scanout = 1;

        general = {
          allow_tearing = !fancy;
          resize_on_border = true;

          # Floating Layout
          snap = {
            enabled = true;
            border_overlap = true;
            respect_gaps = true;
            monitor_gap = 10;
            window_gap = 15;
          };

          # Visuals
          gaps_in = 3;
          gaps_out = 3;
          float_gaps = 3;
          border_size = 2;
          "col.active_border" = mkForce "rgb(${base0D}) rgb(${base05}) 90deg";
        };

        group = {
          auto_group = true;
          insert_after_current = true;
          drag_into_group = 2;
          merge_groups_on_drag = true;
          merge_groups_on_groupbar = true;
          merge_floated_into_tiled_on_groupbar = false;
          group_on_movetoworkspace = false;
          "col.border_active" = mkForce "rgb(${base05}) rgb(${base0D}) 90deg";
          "col.border_inactive" = mkForce "rgb(${base05}) rgb(${base03}) 90deg";

          groupbar = {
            enabled = true;
            scrolling = true;
            gradients = true;
            blur = true;
            height = 15;
            render_titles = true;
            font_size = 10;
            font_weight_active = "bold";
            keep_upper_gap = false;
            middle_click_close = true;
            indicator_height = 0;
            gradient_rounding = 5;
            gradient_round_only_edges = false;
            "col.active" = mkForce "rgba(${base0D}99)";
            "col.inactive" = mkForce "rgb(${base03})";
          };
        };

        animation = mkIf fancy {
          bezier = [
            "accelerate, 0.3, 0, 0.8, 0.15"
            "decelerate, 0.05, 0.7, 0.1, 1"
            "zoom, 0.38, 0.04, 1, 0.07"
            "crash, 0.1, 1, 0, 1"
          ];

          animation = [
            "border, 1, 10, default"
            "fade, 1, 3, decelerate"
            "fadeLayersIn, 1, 2, crash"
            "fadeLayersOut, 1, 0.5, zoom"
            "layersIn, 1, 3, crash, slide"
            "layersOut, 1, 1.6, zoom"
            "specialWorkspace, 1, 3, decelerate, slidevert"
            "windows, 1, 3, decelerate, popin 60%"
            "windowsIn, 1, 3, decelerate, popin 60%"
            "windowsOut, 1, 3, accelerate, popin 60%"
            "workspaces, 1, 7, crash, slide"
          ];
        };

        decoration = mkIf fancy {
          rounding = 10;
          rounding_power = 3.0;
          dim_special = 0.3;

          shadow = {
            enabled = true;
            offset = "0 2";
            range = 20;
          };

          blur = {
            enabled = true;
            brightness = 1.0;
            contrast = 1.0;
            passes = 2;
            input_methods = true;
          };
        };

        debug = {
          disable_logs = false;
          error_position = 1;
        };

        ecosystem = {
          no_update_news = true;
          no_donation_nag = true;
        };
      };
    };
  }
)

## Compositor Settings
_: {
  lib,
  osConfig ? null,
  ...
}:
lib.mkIf (osConfig != null) (
  let
    lua = import ./_lib.nix lib;
    inherit (lua) curve;

    inherit (osConfig.gui) display fancy;
    inherit (osConfig.lib.stylix.colors) base03 base05 base0D;

    gradient = a: b: {
      colors = ["rgb(${a})" "rgb(${b})"];
      angle = 90;
    };
  in {
    gui._unmanaged = ["hyprland"];
    wayland.windowManager.hyprland = {
      inherit (osConfig.programs.hyprland) enable package portalPackage;

      # Use 'nwg-displays' to configure monitors
      extraConfig = ''
        pcall(require, "monitors")
        pcall(require, "workspaces")
      '';

      settings = {
        # Display
        monitor = {
          output = "";
          mode = "preferred";
          position = "auto";
          scale = 1;
        };

        # Touchpad Gestures
        gesture = [
          {
            fingers = 3;
            direction = "horizontal";
            action = "scroll_move";
            scale = 2;
          }
          {
            fingers = 3;
            direction = "vertical";
            action = "workspace";
          }
        ];

        # Smart Gaps
        workspace_rule = [
          {
            workspace = "w[tv1]s[false]";
            gaps_out = 0;
            gaps_in = 0;
          }
          {
            workspace = "f[1]s[false]";
            gaps_out = 0;
            gaps_in = 0;
          }
        ];
        window_rule = [
          {
            name = "no-gaps-wtv1";
            match = {
              float = false;
              workspace = "w[tv1]s[false]";
            };
            border_size = 0;
            rounding = 0;
          }
          {
            name = "no-gaps-f1";
            match = {
              float = false;
              workspace = "f[1]s[false]";
            };
            border_size = 0;
            rounding = 0;
          }
        ];

        # Custom Animations
        curve = lib.optionals fancy [
          (curve "snappy" {
            type = "bezier";
            points = [[0.2 1] [0.25 1]];
          })
          (curve "overshoot" {
            type = "bezier";
            points = [[0.05 0.9] [0.1 1.05]];
          })
          (curve "slide" {
            type = "bezier";
            points = [[0.25 1] [0.5 1]];
          })
        ];
        animation = lib.optionals fancy [
          {
            leaf = "border";
            enabled = true;
            speed = 10;
            bezier = "default";
          }
          {
            leaf = "fade";
            enabled = true;
            speed = 2;
            bezier = "snappy";
          }
          {
            leaf = "fadeLayersIn";
            enabled = true;
            speed = 2;
            bezier = "snappy";
          }
          {
            leaf = "fadeLayersOut";
            enabled = true;
            speed = 0.5;
            bezier = "snappy";
          }
          {
            leaf = "specialWorkspace";
            enabled = true;
            speed = 2.5;
            bezier = "snappy";
            style = "slidevert";
          }
          {
            leaf = "windows";
            enabled = true;
            speed = 2.5;
            bezier = "overshoot";
            style = "popin 70%";
          }
          {
            leaf = "windowsIn";
            enabled = true;
            speed = 2.5;
            bezier = "overshoot";
            style = "popin 70%";
          }
          {
            leaf = "windowsOut";
            enabled = true;
            speed = 2;
            bezier = "snappy";
            style = "popin 70%";
          }
          {
            leaf = "windowsMove";
            enabled = true;
            speed = 2.5;
            bezier = "slide";
          }
          {
            leaf = "workspaces";
            enabled = true;
            speed = 4;
            bezier = "slide";
            style = "slidevert";
          }
        ];

        config =
          {
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
                tap_to_click = true;
                tap_and_drag = true;
                natural_scroll = true;
                disable_while_typing = false;
              };
            };

            # Workspace Behaviour
            binds = {
              workspace_center_on = 1;
              movefocus_cycles_fullscreen = true;
              workspace_back_and_forth = true;
              drag_threshold = 30;
            };

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
            scrolling = {
              column_width = 0.5;
              explicit_column_widths = "0.333, 0.5, 0.667, 1.0";
              follow_focus = true;
              fullscreen_on_one_column = true;
            };
            dwindle = {
              preserve_split = true;
              smart_split = true;
            };

            misc = {
              disable_autoreload = true; # Disable configuration Polling
              enable_swallow = true; # Window Swallowing
              swallow_regex = "^(kitty)$";

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
              layout = "scrolling";

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
              col.active_border = gradient base0D base05;
            };

            group = {
              auto_group = true;
              insert_after_current = true;
              drag_into_group = 2;
              merge_groups_on_drag = true;
              merge_groups_on_groupbar = true;
              merge_floated_into_tiled_on_groupbar = false;
              group_on_movetoworkspace = false;
              col = {
                border_active = gradient base05 base0D;
                border_inactive = gradient base05 base03;
              };

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
                col = {
                  active = "rgba(${base0D}99)";
                  inactive = "rgb(${base03})";
                };
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
          }
          // lib.optionalAttrs fancy {
            decoration = {
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
          };
      };
    };
  }
)

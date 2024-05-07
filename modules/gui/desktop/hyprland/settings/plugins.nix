{
  sys,
  config,
  pkgs,
  files,
  ...
}: {
  ## Plugin Settings
  # Pyprland
  home = {
    packages = with pkgs; [hyprshade unstable.pyprland];
    file = {
      ".config/hypr/pyprland.toml".text = files.hyprland.pypr;
      ".config/hypr/shaders" = {
        source = "${pkgs.custom.hyprland-shaders}/share/hypr/shaders";
        recursive = true;
      };
    };
  };

  wayland.windowManager.hyprland = {
    plugins = with pkgs.hyprworld; [hycov hyprexpo Hyprspace hyprsplit];
    extraConfig = with sys.lib.stylix.colors; let
      gaps =
        builtins.toString
        config.wayland.windowManager.hyprland.settings.general.gaps_in;
    in ''
      plugin {
        # Expose
        hyprexpo {
          columns = 3
          gap_size = ${gaps}
          bg_col = rgb(${base00})
          workspace_method = first 1
          enable_gesture = true
          gesture_positive = false
        }

        # Application Overview
        hycov {
          enable_hotarea = 1
          hotarea_pos = 3
          only_active_workspace = 1
          overview_gappi = 24
          overview_gappo = 60
          enable_gesture = 0
          enable_alt_release_exit = 1
          alt_replace_key = Alt_L
          alt_toggle_auto_next = 1
          enable_click_action = 1
        }

        # Workspace Overview
        overview {
          autoDrag = true
          dragAlpha = 0.4
          exitOnClick = true
          centerAligned = true
          hideTopLayers = true
          hideOverlayLayers = false
          showNewWorkspace = true
          showEmptyWorkspace = false
          overrideGaps = true
          gapsIn = ${gaps}
          gapsOut = ${gaps}
          panelBorderWidth = 1
          panelBorderColor = rgb(${base0A})
          workspaceActiveBorder = rgb(${base0D})
        }

        # Split Monitor Workspaces
        hyprsplit {
          num_workspaces = 9
        }
      }
    '';

    settings = {
      exec-once = ["pypr"];
      bind = [
        # Expose
        "$mod, grave, hyprexpo:expo, toggle"

        # Compositor Shaders
        "$mod, S, exec, hyprutils toggle shader"

        # Application Overview
        "ALT, Tab, hycov:toggleoverview"
        "ALT SHIFT, Tab, hycov:toggleoverview, forceall"
        "ALT, left, hycov:movefocus, l"
        "ALT, right, hycov:movefocus, r"
        "ALT, up, hycov:movefocus, u"
        "ALT, down, hycov:movefocus, d"

        # Workspace Overview
        "$mod, Tab, overview:toggle"
        "$mod SHIFT, Tab, overview:toggle, all"
      ];
    };
  };
}

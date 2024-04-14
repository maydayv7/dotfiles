{
  sys,
  config,
  pkgs,
  files,
  ...
}: let
  inherit (sys.lib.stylix.colors) base00 base0A;
in {
  ## Plugin Settings
  # Pyprland
  home = {
    packages = [pkgs.unstable.pyprland];
    file.".config/hypr/pyprland.toml".text = files.hyprland.pypr;
  };

  wayland.windowManager.hyprland = {
    plugins = with pkgs.wayworld; [hyprexpo Hyprspace];
    extraConfig = let
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
          workspace_method = center current
          enable_gesture = true
          gesture_positive = true
        }

        # Overview
        overview {
          autoDrag = false
          exitOnClick = true
          centerAligned = true
          hideTopLayers = true
          hideOverlayLayers = false
          overrideGaps = true
          gapsIn = ${gaps}
          gapsOut = ${gaps}
          workspaceActiveBorder = rgb(${base0A})
        }
      }
    '';

    settings = {
      exec-once = ["pypr"];
      bind = [
        # Expose
        "$MOD CTRL, TAB, hyprexpo:expo, toggle"

        # Overview
        "$mod, Tab, overview:toggle"
        "$mod SHIFT, Tab, overview:toggle, all"
      ];
    };
  };
}

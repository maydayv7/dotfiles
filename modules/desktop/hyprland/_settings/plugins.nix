## Compositor Plugins
_: {
  lib,
  pkgs,
  osConfig ? null,
  ...
}:
lib.mkIf (osConfig != null) {
  wayland.windowManager.hyprland = {
    plugins = with pkgs.hyprworld; [
      split-monitor-workspaces
      hypr-dynamic-cursors
    ];

    settings.plugin = {
      # Workspaces per Monitor
      split-monitor-workspaces.count = 9;

      # Cursor Effects
      dynamic-cursors = {
        enabled = true;
        mode =
          if osConfig.gui.fancy
          then "tilt"
          else "none";

        hyprcursor = {
          enabled = true;
          nearest = true;
        };

        shake = {
          enabled = true;
          effects = false;
          ipc = false;
        };

        tilt.activation = "negative_quadratic";
      };
    };
  };
}

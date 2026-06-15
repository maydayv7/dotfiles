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
      hyprsplit
    ];

    # Workspaces per Monitor
    settings.plugin.hyprsplit.num_workspaces = 9;
  };
}

_: {
  lib,
  pkgs,
  osConfig ? null,
  ...
}:
lib.mkIf (osConfig != null) {
  ## Plugin Settings
  wayland.windowManager.hyprland = {
    plugins = with pkgs.hyprworld; [
      hyprsplit
    ];

    # Workspaces per Monitor
    settings.plugin.hyprsplit.num_workspaces = 9;
  };
}

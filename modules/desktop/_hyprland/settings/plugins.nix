{sys ? null, ...}: {
  config,
  pkgs,
  ...
}: {
  ## Plugin Settings
  wayland.windowManager.hyprland = {
    plugins = with pkgs.hyprworld; [
      hypr-dynamic-cursors
      hyprexpo
      hyprsplit
    ];

    settings = {
      plugin = {
        # Workspaces per Monitor
        hyprsplit.num_workspaces = 9;

        # Cursor Effects
        dynamic-cursors = {
          enabled = true;
          hyprcursor.enabled = true;
          shake = {
            enabled = true;
            nearest = true;
            effects = false;
            ipc = false;
          };
          mode =
            if sys.gui.fancy
            then "tilt"
            else "none";
          tilt.function = "negative_quadratic";
        };

        # Overview
        hyprexpo = {
          columns = 3;
          workspace_method = "first 1";
          bg_col = "rgb(${sys.lib.stylix.colors.base00})";
          gap_size = builtins.toString config.wayland.windowManager.hyprland.settings.general.gaps_in;
        };
      };

      bind = ["$mod, grave, hyprexpo:expo, toggle"];
      hyprexpo-gesture = [
        "4, up, expo, on"
        "4, down, expo, off"
      ];
    };
  };
}

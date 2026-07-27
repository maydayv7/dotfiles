## Compositor Plugins
_: {
  lib,
  pkgs,
  osConfig ? null,
  ...
}:
lib.mkIf (osConfig != null) (
  let
    inherit (osConfig.gui) fancy;

    lua = import ./_lib.nix lib;
    inherit (lua) inline;
    luaBool = b:
      if b
      then "true"
      else "false";

    cursorMode =
      if fancy
      then "tilt"
      else "none";
  in {
    # Workspaces per Monitor
    xdg.configFile."hypr/hyprsplit/init.lua".source = "${pkgs.custom.hypr-split}/init.lua";
    wayland.windowManager.hyprland = {
      settings.hs = {
        _var = inline ''(function() local hs = require("hyprsplit"); hs.config({ num_workspaces = 9 }); return hs end)()'';
      };

      plugins = with pkgs; [hyprlandPlugins.hypr-dynamic-cursors custom.hypr-overview];
      extraConfig = ''
        -- Cursor Effects
        if hl.plugin.dynamic_cursors then
          hl.config({ plugin = { dynamic_cursors = {
            enabled = true,
            mode = "${cursorMode}",
            hyprcursor = { enabled = true, nearest = 1 },
            shake = { enabled = true, effects = false, ipc = false },
            tilt = { activation = "negative_quadratic" },
          } } })
        end

        -- Workspace Overview
        if hl.plugin.scrolloverview then
          hl.config({ plugin = { scrolloverview = {
            gesture_distance = 300,
            scale = 0.5,
            workspace_gap = 100,
            layout = "vertical",
            wallpaper = 2,
            blur = ${luaBool fancy},
            shadow = { enabled = ${luaBool fancy} },
          } } })

          hl.plugin.scrolloverview.gesture({ fingers = 4, direction = "up" })
        end
      '';
    };
  }
)

## Shell Integration
{files ? null, ...}: {
  home = {
    config,
    lib,
    pkgs,
    ...
  }: {
    programs.noctalia.settings = {
      # Bar
      bar.main = {
        start = ["control-center" "taskbar" "group:g1" "media"];
        capsule_group = [
          {
            id = "g1";
            members = [
              "minimize"
              "maydayv7/hyprland-layout:indicator"
              "maydayv7/hyprland-submap:indicator"
            ];
          }
          {
            id = "g2";
            members = ["tray"];
          }
        ];
      };

      # Minimize Button
      widget.minimize = {
        type = "custom_button";
        glyph = "arrow-bar-to-down";
        tooltip = "Minimize window";
        command = ''hyprctl dispatch 'hl.dsp.window.move({ workspace = "special:minimized", follow = false })' '';
        right_command = "hyprutils toggle minimized";
      };

      # Plugins
      plugins = {
        source = [
          {
            name = "official";
            kind = "git";
            location = "https://github.com/noctalia-dev/official-plugins";
          }
          {
            name = "community";
            kind = "git";
            location = "https://github.com/noctalia-dev/community-plugins";
          }
          {
            name = "local";
            kind = "path";
            location = files.hyprland.noctalia;
          }
        ];
        enabled = [
          "noctalia/screen_recorder"
          "noctalia/timer"
          "maydayv7/hyprland-submap"
          "maydayv7/hyprland-layout"
        ];
      };
      plugin_settings = let
        hyprctl = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl";
        jq = lib.getExe pkgs.jq;
        socket2 = "${lib.getExe pkgs.socat} -u UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock -";
      in {
        "maydayv7/hyprland-submap" = {
          command = socket2;
          aliases = [
            "inhibit=Inhibit"
            "resize=Resize"
            "move=Move"
            "minimized=Minimized"
            "scrolloverview=Overview"
          ];
        };
        "maydayv7/hyprland-layout" = {
          command = socket2;
          layout_command = "${hyprctl} getoption -j general:layout";
          float_command = "${hyprctl} -j clients | ${jq} --argjson ws \"$(${hyprctl} -j activeworkspace | ${jq} .id)\" '[.[] | select(.workspace.id == $ws and .mapped)] as $w | (($w | length) > 0) and ($w | map(.floating) | all)'";
        };
      };
    };
  };
}

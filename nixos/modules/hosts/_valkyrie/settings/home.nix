{
  sys,
  config,
  lib,
  ...
}:
let
  inherit (lib) hasPrefix mkIf mkMerge;
  desktop = name: hasPrefix name sys.gui.desktop;
  control = {
    keyboard = "asusctl aura -n";
    profile = "asusctl profile -n";
  };
in
mkMerge [
  {
    # ROG Control Center
    home.persist.directories = [ ".config/rog" ];
  }

  # Keybinds
  (mkIf (desktop "hyprland") {
    wayland.windowManager.hyprland.settings.bindl = [
      ", XF86Launch3, exec, ${control.keyboard}"
      ", XF86Launch4, exec, ${control.profile}"
    ];
  })

  (mkIf (desktop "niri") {
    programs.niri.settings.binds =
      let
        run = command: config.lib.niri.actions.spawn "sh" "-c" command;
      in
      {
        "XF86Launch3".action = run control.keyboard;
        "XF86Launch4".action = run control.profile;
      };
  })

  (mkIf (desktop "gnome") {
    dconf.settings = {
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
        ];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
        binding = "Launch3";
        command = control.keyboard;
        name = "Keyboard Mode";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
        binding = "Launch4";
        command = control.profile;
        name = "Platform Profile";
      };
    };
  })
]

{
  config,
  lib,
  util,
  pkgs,
  files,
  ...
}:
let
  inherit (lib) getExe;
  inherit (config.lib.stylix) colors;
in
{
  environment.systemPackages = with pkgs; [
    # Apps
    custom.kebihelp
    nwg-displays

    # Utilities
    custom.hyprutils
    grim
    grimblast
    hyprkeys
    hyprshade
    hyprsunset
    unstable.pyprland
    slurp
    waycorner
  ];

  user.homeConfig = {
    services = {
      # Wallpaper Daemon
      hyprpaper = {
        enable = true;
        settings = {
          ipc = false;
          splash = true;
        };
      };

      # Display Temperature
      hyprsunset = {
        enable = true;
        extraArgs = [ "--identity" ];
        settings.profile = [
          {
            time = "7:00";
            temperature = 6000;
          }
          {
            time = "19:00";
            temperature = 4500;
          }
        ];
      };
    };

    systemd.user.services.waycorner =
      let
        target = [ "graphical-session.target" ];
      in
      {
        Install.WantedBy = target;
        Unit = {
          Description = "Hot Corners";
          After = target;
        };
        Service.ExecStart = getExe pkgs.waycorner;
      };

    home = {
      persist.directories = [ ".config/nwg-displays" ];
      file = with files.hyprland; {
        # Application Drawer
        ".config/nwg-drawer/drawer.css".text = drawer;

        # Pyprland
        ".config/hypr/pyprland.toml".text = pypr;

        # Hot Corners
        ".config/waycorner/config.toml".text = waycorner;

        # Keybinds Viewer
        ".config/kebihelp.json".text = util.build.theme {
          inherit colors;
          inherit (config.stylix) fonts;
          file = kebihelp;
        };

        # Shaders
        ".config/hypr/shaders" = {
          source = shaders;
          recursive = true;
        };
      };
    };
  };
}

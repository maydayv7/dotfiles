{
  util ? null,
  files ? null,
  ...
}: {
  nixos = _: {
    # User Authentication
    security = {
      soteria.enable = true;
      pam.services.swaylock.text = "auth include login";
    };
  };

  home = {
    config,
    lib,
    pkgs,
    ...
  }: let
    idle = import ../_idle.nix lib pkgs;
    inherit (idle) locker;
  in {
    # Locker
    stylix.targets.swaylock = {
      enable = true;
      useWallpaper = true;
    };

    programs.swaylock = {
      enable = true;
      package = locker;
      settings = {
        clock = true;
        indicator = true;
        font = config.stylix.fonts.sansSerif.name;
        effect-vignette = "0.3:1";
      };
    };

    # Idle Daemon
    services.swayidle = with idle; {
      enable = true;
      extraArgs = ["-w"];
      events = {
        before-sleep = lock pause "";
        lock = lock pause "--fade-in 0.2 --grace 15 --grace-no-mouse";
      };
    };

    # Logout
    programs.wlogout = {
      enable = true;
      style = util.build.theme {
        inherit (config.lib.stylix) colors;
        file = files.wlogout;
      };

      layout = [
        {
          label = "lock";
          action = "loginctl lock-session";
          text = "";
          keybind = "l";
        }
        {
          label = "logout";
          action = "loginctl terminate-user $USER";
          text = "↶";
          keybind = "e";
        }
        {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "⏻";
          keybind = "s";
        }
        {
          label = "reboot";
          action = "systemctl reboot";
          text = "↺";
          keybind = "r";
        }
        {
          label = "suspend";
          action = "systemctl suspend";
          text = "";
          keybind = "u";
        }
        {
          label = "hibernate";
          action = "systemctl hibernate";
          text = "";
          keybind = "h";
        }
      ];
    };

    home.file.".config/kwalletrc".text = ''
      [Wallet]
      Enabled=false
    '';
  };
}

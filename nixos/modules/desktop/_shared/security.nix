{
  config,
  lib,
  util,
  pkgs,
  files,
  ...
}:
let
  inherit (lib)
    getExe
    getExe'
    mkIf
    mkOption
    types
    ;

  locker = pkgs.swaylock-effects;
in
{
  ## Security Configuration
  options._shared.idle = mkOption {
    description = "INTERNAL: Shared Idle Configuration";
    type = types.attrs;
  };

  config = mkIf config._shared.enable rec {
    # User Authentication
    security = {
      soteria.enable = true;
      pam.services.swaylock.text = "auth include login";
    };

    # Idle Scripts
    _shared.idle = {
      lock =
        pre: flag:
        "sh -c 'if ! ${getExe' pkgs.procps "pgrep"} -x swaylock; then ${pre} ${getExe locker} -f ${flag}; fi'";

      pause = "${getExe pkgs.playerctl} pause -a;";
      audio =
        command:
        "${pkgs.writeShellScript "audio" ''
          ${getExe pkgs.playerctl} status | ${getExe pkgs.gnugrep} Playing
          if [ $? == 1 ]; then ${command}; fi
        ''}"; # Check if audio is playing
    };

    user.homeConfig = {
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
      services.swayidle = with _shared.idle; {
        enable = true;
        extraArgs = [ "-w" ];
        events = [
          {
            event = "before-sleep";
            command = lock pause "";
          }
          {
            event = "lock";
            command = lock pause "--fade-in 0.2 --grace 15 --grace-no-mouse";
          }
        ];
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
            text = "";
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
            text = "";
            keybind = "u";
          }
          {
            label = "hibernate";
            action = "systemctl hibernate";
            text = "";
            keybind = "h";
          }
        ];
      };
    };
  };
}

{
  sys,
  lib,
  pkgs,
  files,
  ...
}: let
  inherit (lib) concatMapStringsSep getExe;
  inherit (sys.stylix) fonts;
  locker = pkgs.swaylock-effects;
in {
  # Locker
  programs.swaylock = {
    enable = true;
    package = locker;
    settings = {
      clock = true;
      indicator = true;
      font = fonts.sansSerif.name;
      fade-in = 1;
      effect-vignette = "0.3:1";
    };
  };

  # Theming
  stylix.targets.swaylock = {
    enable = true;
    useImage = true;
  };

  # Idle Daemon
  services.swayidle = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    events = let
      toggle = "${getExe pkgs.custom.hyprutils} toggle media";
      lock = flag: "sh -c '${toggle}; ${getExe locker} ${flag}; ${toggle}'";
    in [
      {
        event = "before-sleep";
        command = lock "";
      }
      {
        event = "lock";
        command = lock "--grace 10";
      }
    ];
    timeouts = [
      {
        timeout = 500;
        command = "${pkgs.writeShellApplication {
          name = "suspend"; # Suspend if no audio is playing
          runtimeInputs = with pkgs; [pipewire gnugrep systemd];
          text = ''
            pw-cli info all | grep running
            if [ $? == 1 ]; then systemctl suspend; fi
          '';
        }}/bin/suspend";
      }
      (let
        script = text: "${pkgs.writeShellApplication {
          name = "dpms";
          runtimeInputs = [sys.programs.hyprland.package pkgs.procps];
          inherit text;
        }}/bin/dpms";
      in {
        timeout = 30; # Turn off display after locking
        command = script "if pgrep -x swaylock; then hyprctl dispatch dpms off; fi";
        resumeCommand = script "hyprctl dispatch dpms on";
      })
    ];
  };

  # Logout
  programs.wlogout = {
    enable = true;
    style =
      files.hyprland.wlogout
      + ''
        ${concatMapStringsSep "\n" (
            name: ''
              #${name} {
                background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/${name}.png"));
              }
            ''
          ) [
            "lock"
            "logout"
            "suspend"
            "hibernate"
            "shutdown"
            "reboot"
          ]}
      '';
  };

  # Authorization Agent
  systemd.user.services.polkit = {
    Unit.Description = "Polkit Authentication (GNOME)";

    Install = {
      WantedBy = ["graphical-session.target"];
      Wants = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}

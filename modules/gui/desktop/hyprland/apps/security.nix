{
  sys,
  lib,
  pkgs,
  files,
  ...
}: rec {
  # Locker
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      clock = true;
      indicator = true;
      font = sys.stylix.fonts.sansSerif.name;
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
  services.swayidle = let
    inherit (lib) getExe getExe';
    toggle = "${getExe pkgs.custom.hyprutils} toggle media";
    lock = flag: "sh -c '${toggle}; ${getExe programs.swaylock.package} ${flag}; ${toggle}'";
  in {
    enable = true;
    systemdTarget = "hyprland-session.target";
    events = [
      {
        event = "before-sleep";
        command = lock "";
      }
      {
        event = "lock";
        command = lock "--grace 10";
      }
    ];
    timeouts = let
      script = command: getExe (pkgs.writeShellScript "idle" command);
      hyprctl = getExe' sys.programs.hyprland.package "hyprctl";
    in [
      {
        timeout = 300; # Turn off display and lock
        command = script "${hyprctl} dispatch dpms off; ${lock ""}";
        resumeCommand = script "${hyprctl} dispatch dpms on";
      }
      {
        timeout = 1000; # Suspend if no audio is playing
        command = script ''
          ${getExe' pkgs.pipewire "pw-cli"} info all | ${getExe pkgs.gnugrep} running
          if [ $? == 1 ]; then ${getExe' pkgs.systemd "systemctl"} suspend; fi
        '';
      }
    ];
  };

  # Logout
  programs.wlogout = {
    enable = true;
    style =
      files.hyprland.wlogout
      + ''
        ${lib.concatMapStringsSep "\n" (
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

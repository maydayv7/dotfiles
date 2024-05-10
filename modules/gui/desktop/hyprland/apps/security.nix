{
  sys,
  lib,
  pkgs,
  files,
  ...
}: rec {
  # Locker
  stylix.targets.swaylock = {
    enable = true;
    useImage = true;
  };

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
      audio = command: "${pkgs.writeShellScript "audio" ''
        ${getExe' pkgs.pipewire "pw-cli"} info all | ${getExe pkgs.gnugrep} running
        if [ $? == 1 ]; then ${command}; fi
      ''}"; # Check if audio is playing
      hyprctl = getExe' sys.programs.hyprland.package "hyprctl";
    in [
      {
        timeout = 300; # Turn off display
        command = audio "${hyprctl} dispatch dpms off";
        resumeCommand = "${hyprctl} dispatch dpms on";
      }
      {
        timeout = 600; # Suspend then Hibernate computer
        command = audio "${hyprctl} dispatch dpms on && ${getExe' pkgs.systemd "systemctl"} suspend-then-hibernate";
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

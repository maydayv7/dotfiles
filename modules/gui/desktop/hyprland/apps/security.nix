{
  sys,
  lib,
  pkgs,
  files,
  ...
}: let
  inherit (lib) concatMapStringsSep getExe getExe';
  locker = pkgs.swaylock-effects;
in {
  # Locker
  stylix.targets.swaylock = {
    enable = true;
    useImage = true;
  };

  programs.swaylock = {
    enable = true;
    package = locker;
    settings = {
      clock = true;
      indicator = true;
      font = sys.stylix.fonts.sansSerif.name;
      fade-in = 1;
      effect-vignette = "0.3:1";
    };
  };

  # Idle Daemon
  services.swayidle = {
    enable = true;
    systemdTarget = "hyprland-session.target";

    events = let
      toggle = "${getExe pkgs.custom.hyprutils} toggle media";
      lock = command: "sh -c 'if ! ${getExe' pkgs.procps "pgrep"} -x swaylock; then ${command}; fi'";
    in [
      {
        event = "before-sleep";
        command = lock (getExe locker);
      }
      {
        event = "lock";
        command = lock "${toggle}; ${getExe locker} --grace 10; ${toggle}";
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
        timeout = 600; # Suspend then Hibernate device
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
    Unit.Description = "Polkit Authentication";

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

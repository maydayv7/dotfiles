{
  sys,
  lib,
  pkgs,
  files,
  ...
}: let
  inherit (sys.stylix) fonts;
in {
  # Locker
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      clock = true;
      indicator = true;
      font = fonts.sansSerif.name;
      grace = 10;
      fade-in = 1;
      effect-vignette = "0.3:1";
    };
  };

  # Theming
  stylix.targets.swaylock = {
    enable = true;
    useImage = true;
  };

  # Screen Idle
  services.swayidle = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.systemd}/bin/loginctl lock-session";
      }
      {
        event = "lock";
        command = "${pkgs.swaylock-effects}/bin/swaylock -f";
      }
    ];
    timeouts = [
      {
        timeout = 330;
        command = "${pkgs.writeShellApplication {
          name = "suspend"; # Only suspend if no audio is playing
          runtimeInputs = with pkgs; [pipewire ripgrep systemd];
          text = ''
            pw-cli i all | rg running
            if [ $? == 1 ]
            then
              ${pkgs.systemd}/bin/systemctl suspend
            fi
          '';
        }}/bin/suspend";
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
    Unit.Description = "polkit-gnome-authentication-agent-1";

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

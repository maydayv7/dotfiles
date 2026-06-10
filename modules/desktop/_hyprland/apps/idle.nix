_: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe getExe';
in {
  ## Idle Timeout
  user.homeConfig.services.swayidle.timeouts = with config._shared.idle; let
    shader = getExe pkgs.hyprshade;
    dpms = "${getExe' config.programs.hyprland.package "hyprctl"} dispatch dpms";
  in [
    {
      timeout = 240; # Dim display
      command = audio "${shader} on dim";
      resumeCommand = "${shader} off";
    }
    {
      timeout = 300; # Turn off display
      command = audio "${dpms} off";
      resumeCommand = "${dpms} on";
    }
    {
      timeout = 500; # Suspend device
      command = audio "${dpms} on && ${lock "" ""} && ${getExe' pkgs.systemd "systemctl"} suspend";
    }
  ];
}

_: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe';
in {
  ## Idle Timeout
  user.homeConfig.services.swayidle.timeouts = with config._shared.idle; let
    dpms = state: "${getExe' config.programs.niri.package "niri"} msg action power-${state}-monitors";
  in [
    {
      timeout = 300; # Turn off display
      command = audio (dpms "off");
      resumeCommand = dpms "on";
    }
    {
      timeout = 500; # Suspend device
      command = audio "${dpms "on"} && ${lock "" ""} && ${getExe' pkgs.systemd "systemctl"} suspend";
    }
  ];
}

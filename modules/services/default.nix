{ config, lib, pkgs, ... }:
{  
  # Touchegg X11 Gestures Daemon
  systemd.services.touchegg =
  {
    enable = true;
    description = "The daemon for Touchégg X11 Gestures.";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = 
    {
      Type = "simple";
      Group = "input";
      Restart = "on-failure";
      RestartSec = 5;
      ExecStart = "${pkgs.touchegg}/bin/touchegg --daemon";
    };
  };
}

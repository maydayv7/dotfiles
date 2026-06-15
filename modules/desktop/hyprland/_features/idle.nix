_: {
  home = {
    lib,
    pkgs,
    osConfig ? null,
    ...
  }:
    lib.mkIf (osConfig != null) (
      let
        inherit (lib) getExe getExe';
        idle = import ../_idle.nix lib pkgs;
        shader = getExe pkgs.hyprshade;
        dpms = "${getExe' osConfig.programs.hyprland.package "hyprctl"} dispatch dpms";
      in {
        services.swayidle.timeouts = with idle; [
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
    );
}

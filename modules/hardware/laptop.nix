{
  config,
  lib,
  ...
}: let
  enable = builtins.elem "laptop" config.hardware.support;
in {
  ## Laptop Configuration ##
  config = lib.mkIf enable {
    # Lid
    services.logind.extraConfig = ''
      HandleLidSwitch=lock
      HandleLidSwitchExternalPower=lock
    '';

    # Touchpad
    services.xserver.libinput = {
      enable = true;
      touchpad = {
        tapping = true;
        tappingDragLock = true;
        middleEmulation = true;
        naturalScrolling = false;
        disableWhileTyping = true;
        scrollMethod = "twofinger";
        accelSpeed = "0.7";
      };
    };
  };
}

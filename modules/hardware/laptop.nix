{
  config,
  lib,
  pkgs,
  files,
  ...
}: let
  enable = builtins.elem "laptop" config.hardware.support;
in {
  ## Laptop Configuration ##
  config = lib.mkIf enable {
    services.logind = {
      killUserProcesses = true;

      # Power Button
      powerKey = "poweroff";
      powerKeyLongPress = "reboot";

      # Lid
      lidSwitch = "lock";
      lidSwitchDocked = "ignore";
    };

    # Audio
    user.homeConfig.home.file.".config/autostart/audio-tweaks.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=audio-tweaks
      Exec=${pkgs.writeShellApplication {
        name = "audio";
        text = files.scripts.audio;
        runtimeInputs = with pkgs; [glib playerctl];
      }}/bin/audio
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

    # Battery
    powerManagement = {
      enable = true;
      powertop.enable = true;
    };
  };
}

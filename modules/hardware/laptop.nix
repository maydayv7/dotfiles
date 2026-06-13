## Laptop Configuration ##
{config, ...}: let
  inherit (config.flake) files;
in {
  flake.modules = {
    nixos.laptop = _: {
      services.logind.settings.Login = {
        KillUserProcesses = true;

        # Power Button
        HandlePowerKey = "poweroff";
        HandlePowerKeyLongPress = "reboot";

        # Lid
        HandleLidSwitch = "lock";
        HandleLidSwitchDocked = "ignore";
      };

      # Touchpad
      services.libinput = {
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

    homeManager.laptop = {pkgs, ...}: {
      # Audio
      home.file.".config/autostart/audio-tweaks.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Name=audio-tweaks
        Exec=${
          pkgs.writeShellApplication {
            name = "audio";
            text = files.scripts.audio;
            runtimeInputs = with pkgs; [
              glib
              playerctl
            ];
          }
        }/bin/audio
      '';
    };
  };
}

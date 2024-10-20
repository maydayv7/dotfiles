{
  config,
  lib,
  ...
}: let
  inherit (lib) mkForce;
  mode = config.hardware.cpu.mode == "performance";
in {
  user.persist.directories = [".config/rog"];
  boot.kernelParams = ["nvidia_drm.fbdev=1"];
  services = {
    fwupd.enable = true;
    xserver.videoDrivers = mkForce ["nvidia"];
    udev.extraHwdb = ''
      evdev:name:Asus Keyboard:*
        KEYBOARD_KEY_7003f=print
    '';
  };

  #!# Run 'amixer -c 2 sset "Internal Mic Boost" 0' if microphone is garbled

  hardware = {
    vm.passthrough = ["10de:28e0" "10de:22be"];
    nvidia = {
      dynamicBoost.enable = true;
      prime = {
        nvidiaBusId = mkForce "PCI:1:0:0";
        amdgpuBusId = mkForce "PCI:101:0:0";
        sync.enable = false;
        reverseSync.enable = mkForce mode;
        offload = {
          enable = mkForce (!mode);
          enableOffloadCmd = mkForce (!mode);
        };
      };
    };
  };
}

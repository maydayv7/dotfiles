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

    asusd = {
      enable = true;
      enableUserService = true;
      asusdConfig = ''
        (
          boot_sound: false,
          change_throttle_policy_on_ac: true,
          change_throttle_policy_on_battery: true,
          charge_control_end_threshold: 95,
          disable_nvidia_powerd_on_battery: true,
          mini_led_mode: false,
          panel_od: false,
          throttle_balanced_epp: BalancePower,
          throttle_performance_epp: Performance,
          throttle_policy_linked_epp: true,
          throttle_policy_on_ac: Performance,
          throttle_policy_on_battery: Quiet,
          throttle_quiet_epp: Power,
        )'';
    };
  };

  #!# Run 'amixer -c 2 sset "Internal Mic Boost" 0' if microphone is garbled

  hardware = {
    vm.passthrough = ["10de:28e0" "10de:22be"];
    nvidia = {
      dynamicBoost.enable = true;
      powerManagement.enable = true;
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

      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "555.58.02";
        sha256_64bit = "sha256-xctt4TPRlOJ6r5S54h5W6PT6/3Zy2R4ASNFPu8TSHKM=";
        sha256_aarch64 = "sha256-8hyRiGB+m2hL3c9MDA/Pon+Xl6E788MZ50WrrAGUVuY=";
        openSha256 = "sha256-8hyRiGB+m2hL3c9MDA/Pon+Xl6E788MZ50WrrAGUVuY=";
        settingsSha256 = "sha256-ZpuVZybW6CFN/gz9rx+UJvQ715FZnAOYfHn5jt5Z2C8=";
        persistencedSha256 = "sha256-xctt4TPRlOJ6r5S54h5W6PT6/3Zy2R4ASNFPu8TSHKM=";
      };
    };
  };
}

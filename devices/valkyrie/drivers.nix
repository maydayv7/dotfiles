{
  config,
  lib,
  ...
}: let
  inherit (lib) hasPrefix mkForce mkIf;
  enable = config.hardware.vm.vfio != "on";
  mode = config.hardware.cpu.mode == "performance";
in {
  services.fwupd.enable = true;

  # Discrete GPU
  services.xserver.videoDrivers = mkForce ["nvidia"];
  boot.kernelParams = [
    "nvidia_drm.fbdev=1" # Wayland Support
    "NVreg_UsePageAttributeTable=1" # PAT Support
    "NVreg_RegistryDwords=RMUseSwI2c=0x01;RMI2cSpeed=100" # DDC/CI Support

    # https://gitlab.freedesktop.org/drm/amd/-/issues/3388
    (mkIf mode "amdgpu.dcdebugmask=0x10")
  ];

  hardware = {
    vm.passthrough = ["10de:28e0" "10de:22be"];
    nvidia = {
      dynamicBoost = {inherit enable;};
      powerManagement = {inherit enable;};
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

  # Remap Keys
  services.udev.extraHwdb = ''
    evdev:name:Asus Keyboard:*
      KEYBOARD_KEY_7003f=print # F6 -> PrtSc Key
  '';

  # ASUS Software
  user.persist.directories = [".config/rog"];
  services.asusd = {
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

  user.homeConfig.dconf.settings = mkIf (hasPrefix "gnome" config.gui.desktop) {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      binding = "Launch3";
      command = "asusctl led-mode -n";
      name = "Keyboard Mode";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
      binding = "Launch4";
      command = "asusctl profile -n";
      name = "Fan Control";
    };
  };
}

{
  config,
  lib,
  ...
}:
{
  imports = [ ./network.nix ];

  # ! # https://gitlab.freedesktop.org/drm/amd/-/issues/3388
  boot.kernelParams = lib.mkIf (config.hardware.cpu.mode == "performance") [
    "amdgpu.dcdebugmask=0x10"
  ];

  services = {
    fwupd.enable = true;

    # Remap Keys
    udev.extraHwdb = ''
      evdev:name:Asus Keyboard:*
        KEYBOARD_KEY_7003f=print # F6 -> PrtSc Key
    '';
  };

  # ASUS Software
  user.homeConfig.imports = [ ./home.nix ];
  services.asusd = {
    enable = true;
    enableUserService = true;
    asusdConfig.text = builtins.readFile ./asusd.ron;
    auraConfigs."19b6".text = builtins.readFile ./aura.ron;
  };
}

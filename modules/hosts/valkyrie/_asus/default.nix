_: {
  nixos = {
    config,
    lib,
    ...
  }: {
    boot = {
      plymouth.extraConfig = "DeviceScale=2";

      # ! # https://gitlab.freedesktop.org/drm/amd/-/issues/3388
      kernelParams = lib.mkIf (config.hardware.cpu.mode == "performance") [
        "amdgpu.dcdebugmask=0x10"
        "usbcore.autosuspend=-1"
      ];
    };

    services = {
      fwupd.enable = true;

      # Remap Keys
      udev.extraHwdb = ''
        evdev:name:ASUSTek Computer Inc. N-KEY Device:*
          KEYBOARD_KEY_7003f=sysrq # F6 -> PrtSc Key
      '';

      # ASUS Software
      asusd = {
        enable = true;
        asusdConfig.text = builtins.readFile ./asusd.ron;
        auraConfigs."19b6".text = builtins.readFile ./aura.ron;
        fanCurvesConfig.text = builtins.readFile ./fan_curves.ron;
      };
    };
  };

  home = {lib, ...}: {
    # Keybinds
    wayland.windowManager.hyprland.settings.bind = let
      inline = lib.generators.mkLuaInline;
      locked = {locked = true;};
    in [
      {_args = ["XF86Launch3" (inline ''hl.dsp.exec_cmd("asusctl aura -n")'') locked];}
      {_args = ["XF86Launch4" (inline ''hl.dsp.exec_cmd("asusctl profile -n")'') locked];}
    ];
  };
}

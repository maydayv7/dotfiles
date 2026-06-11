## Device Firmware ##
_: {
  flake.modules.nixos.mobile = {pkgs, ...}: {
    programs.adb.enable = true;
    users.groups.adbusers = {};

    services.usbmuxd.enable = true;
    environment.systemPackages = with pkgs; [
      libimobiledevice
      scrcpy
    ];
  };
}

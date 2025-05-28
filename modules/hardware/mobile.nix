{
  config,
  lib,
  pkgs,
  ...
}:
let
  enable = builtins.elem "mobile" config.hardware.support;
in
{
  ## Device Firmware ##
  config = lib.mkIf enable {
    # Android Compatibilty
    user.groups = [ "adbusers" ];
    programs.adb.enable = true;

    # iOS Compatibility
    services.usbmuxd.enable = true;
    environment.systemPackages = with pkgs; [
      libimobiledevice
      scrcpy
    ];

    # ? # Run 'systemctl restart usbmuxd.service' if it doesn't work
  };
}

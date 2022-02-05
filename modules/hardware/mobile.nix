{ config, lib, pkgs, ... }:
let enable = builtins.elem "mobile" config.hardware.support;
in {
  ## Device Firmware ##
  config = lib.mkIf enable {
    ## Android Compatibilty Configuration ##
    # Android Device Bridge
    user.groups = [ "adbusers" ];
    programs.adb.enable = true;

    ## iOS Compatibilty Configuration ##
    # File Transfer
    services.usbmuxd.enable = true;
    environment.systemPackages = [ pkgs.libimobiledevice ];
  };
}

{ config, lib, pkgs, ... }:
let
  enable = config.hardware.mobile;
in rec
{
  options.hardware.mobile = lib.mkEnableOption "Enable Support for Mobile Devices";

  ## Device Firmware ##
  config = lib.mkIf enable
  {
    ## Android Compatibilty Configuration ##
    # Android Device Bridge
    programs.adb.enable = true;
    
    ## iOS Compatibilty Configuration ##
    # File Transfer
    services.usbmuxd.enable = true;
    environment.systemPackages = with pkgs; [ libimobiledevice ];
  };
}

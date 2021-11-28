{ config, lib, username, pkgs, ... }:
let
  enable = (builtins.elem "mobile" config.hardware.support);
in rec
{
  ## Device Firmware ##
  config = lib.mkIf enable
  {
    ## Android Compatibilty Configuration ##
    # Android Device Bridge
    users.users."${username}".extraGroups = [ "adbusers" ];
    programs.adb.enable = true;
    
    ## iOS Compatibilty Configuration ##
    # File Transfer
    services.usbmuxd.enable = true;
    environment.systemPackages = with pkgs; [ libimobiledevice ];
  };
}

{ lib, pkgs, ... }:
{
  ## iOS Compatibilty Configuration ##
  # File Transfer
  services.usbmuxd.enable = true;
  environment.systemPackages = with pkgs; [ libimobiledevice ];
}

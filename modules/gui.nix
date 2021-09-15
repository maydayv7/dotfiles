{ config, lib, pkgs, ... }:
{
  # GUI
  services.xserver =
  {
    enable = true;
    autorun = true;
    layout = "us";
    videoDrivers = [ "modesetting" ];
    useGlamor = true;
    libinput.enable = true;
    libinput.touchpad.tapping = true;
    libinput.touchpad.tappingDragLock = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
}

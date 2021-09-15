{ config, lib, pkgs, ... }:
{
  services.xserver =
  {
    enable = true;
    autorun = true;
    layout = "us";
    
    # Driver Setting
    videoDrivers = [ "modesetting" ];
    useGlamor = true;
    
    # Touchpad
    libinput.enable = true;
    libinput.touchpad.tapping = true;
    libinput.touchpad.tappingDragLock = true;
    
    # GNOME
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
}

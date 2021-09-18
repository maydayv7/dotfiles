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
  
  # Localization
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_IN.UTF-8";
  console =
  {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
    packages = with pkgs; [ terminus_font ];
    keyMap = "us";
  };
}

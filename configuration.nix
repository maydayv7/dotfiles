{ config, lib, pkgs, ... }:
{
  imports =
  [
    # Modules
    ./modules
    
    # Overlays
    ./overlays
    
    # User Configuration
    ./users
  ];
  
  # System Configuration
  system.stateVersion = "21.05";
  users.mutableUsers = false;
  
  # Environment Configuration
  environment =
  {
    pathsToLink = [ "/share/zsh" ];
    variables =
    {
      EDITOR = "nano";
    };
    shells = with pkgs; [ bashInteractive zsh ];
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

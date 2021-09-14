{ config, lib, pkgs, ... }:
{
  imports =
  [
    # Package List
    ./modules/packages.nix
    
    # Boot Configuration
    ./modules/boot.nix
    
    # Hardware Configuration
    ./modules/hardware.nix
    
    # GUI Configuration
    ./modules/gui.nix
    
    # Program Configuration
    ./modules/programs.nix
    
    # User Configuration
    ./users/root/user.nix # User root
    ./users/v7/user.nix   # User V 7
  ];
  
  # System Configuration
  system.stateVersion = "21.05";
  nixpkgs.config.allowUnfree = true;
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
  
  # Overlays
  nixpkgs.overlays = 
  [ 
    (import ./overlays/touchegg.nix)
    (import ./overlays/plymouth.nix)
    (import ./overlays/sof-firmware.nix)
  ];
}

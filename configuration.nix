{ config, lib, pkgs, ... }:
{
  imports =
  [
    # Modules
    ./modules
    
    # Overlays
    ./overlays
    
    # Private Information
    ./secrets
    
    # User Specified Configuration Path
    ./profiles.nix
  ];
  
  # System Configuration
  system.stateVersion = "21.05";
  users.mutableUsers = false;
  nix.trustedUsers = [ "root" "v7" ];
  
  # Environment Configuration
  environment =
  {
    pathsToLink = [ "/share/zsh" ];
    variables =
    {
      EDITOR = "nano";
    };
    shells = with pkgs; [ bashInteractive zsh ];
    etc =
    {
      "nixos".source = "/data/V7/Other/Projects/nixos-config";
    };
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

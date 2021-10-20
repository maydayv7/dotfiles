{ config, lib, pkgs, ... }:
{
  ## GNOME Terminal Settings ##
  programs.gnome-terminal =
  {
    enable = true;
    
    # Terminal Profiles
    profile.v7 =
    {
      default = true;
      visibleName = "Terminal";
      audibleBell = false;
      cursorShape = "ibeam";
      scrollbackLines = 70000;
    };
  };
}

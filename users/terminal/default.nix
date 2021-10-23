{ lib, ... }:
{
  ## GNOME Terminal Settings ##
  programs.gnome-terminal =
  {
    enable = true;
    
    # Terminal Profiles
    profile.terminal =
    {
      default = true;
      visibleName = "Terminal";
      audibleBell = false;
      cursorShape = "ibeam";
      scrollbackLines = 70000;
    };
  };
}

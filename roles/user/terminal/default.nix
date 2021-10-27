{ lib, ... }:
{
  ## GNOME Terminal Settings ##
  programs.gnome-terminal =
  {
    enable = true;
    
    # Terminal Profiles
    profile."b1dcc9dd-5262-4d8d-a863-c897e6d979b9" =
    {
      default = true;
      visibleName = "Terminal";
      audibleBell = false;
      cursorShape = "ibeam";
      scrollbackLines = 70000;
    };
  };
}

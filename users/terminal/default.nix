{ config, lib, pkgs, ... }:
{
  # GNOME Terminal Settings
  programs.gnome-terminal =
  {
    enable = true;
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

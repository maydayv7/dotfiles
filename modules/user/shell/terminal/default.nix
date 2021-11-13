{ config, lib, ... }:
let
  enable = config.shell.terminal.enable;
in rec
{
  options.shell.terminal.enable = lib.mkOption
  {
    description = "User Terminal Configuration";
    type = lib.types.bool;
    default = false;
  };

  ## GNOME Terminal Settings ##
  config = lib.mkIf enable
  {
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
  };
}

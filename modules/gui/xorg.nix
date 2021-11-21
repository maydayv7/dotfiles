{ config, files, username, lib, ... }:
let
  enable = config.gui.enableXorg;
in rec
{
  options.gui.enableXorg = lib.mkEnableOption "Enable XORG Configuration";

  ## XORG Configuration ##
  config = lib.mkIf enable
  {
    services.xserver =
    {
      enable = true;
      autorun = true;
      layout = "us";

      # Driver Settings
      videoDrivers = [ "modesetting" ];
      useGlamor = true;
    };

    # Additional Configuration
    home-manager.users."${username}".xresources.extraConfig = files.xorg;
  };
}

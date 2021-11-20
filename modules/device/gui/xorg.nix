{ config, lib, ... }:
let
  enable = config.gui.xorg.enable;
in rec
{
  options.gui.xorg.enable = lib.mkOption
  {
    description = "Enable XORG Configuration";
    type = lib.types.bool;
    default = false;
  };

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
  };
}

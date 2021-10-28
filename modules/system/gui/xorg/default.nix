{ config, lib, ... }:
with lib;
with builtins;
let
  cfg = config.gui.xorg;
in rec
{
  options.gui.xorg.enable = mkOption
  {
    description = "XORG Configuration";
    type = types.bool;
    default = false;
  };
  
  config = mkIf (cfg.enable == true)
  {
    ## Xorg Configuration ##
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

{ config, lib, ... }:
with lib;
with builtins;
let
  cfg = config.hardware.ssd;
in rec
{
  options.hardware.ssd = mkOption
  {
    description = "SSD Configuration";
    type = types.bool;
    default = false;
  };
  
  config = mkIf (cfg == true)
  {
    ## Additional SSD Settings ##
    # SSD Trim
    services.fstrim.enable = true;
  };
}

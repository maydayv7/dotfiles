{ config, lib, ... }:
let
  cfg = config.hardware.ssd;
in rec
{
  options.hardware.ssd = lib.mkOption
  {
    description = "SSD Configuration";
    type = lib.types.bool;
    default = false;
  };

  ## Additional SSD Settings ##
  config = lib.mkIf (cfg == true)
  {
    # SSD Trim
    services.fstrim.enable = true;
  };
}

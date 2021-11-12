{ config, lib, ... }:
let
  cfg = config.hardware.ssd;
in rec
{
  options.hardware.ssd = lib.mkOption
  {
    description = "SSD Configuration";
    type = lib.types.bool;
  };

  ## Additional SSD Settings ##
  config = lib.mkIf cfg
  {
    # SSD Trim
    services.fstrim.enable = true;
  };
}

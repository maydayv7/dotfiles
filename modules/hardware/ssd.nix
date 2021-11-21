{ config, lib, ... }:
let
  enable = config.hardware.ssd;
in rec
{
  options.hardware.ssd = lib.mkEnableOption "SSD Configuration";

  ## Additional SSD Settings ##
  config = lib.mkIf enable
  {
    # SSD Trim
    services.fstrim.enable = true;
  };
}

{ config, lib, ... }:
let
  enable = (builtins.elem "ssd" config.hardware.support);
in rec
{
  ## SSD Settings ##
  config = lib.mkIf enable
  {
    # SSD Trim
    services.fstrim.enable = true;
  };
}

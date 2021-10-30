{ config, lib, ... }:
let
  cfg = config.base.enable;
in rec
{
  ## Security Settings ##
  config = lib.mkIf (cfg == true)
  {
    security =
    {
      sudo.extraConfig =
      "
        Defaults pwfeedback
        Defaults lecture = never
      ";
    };
  };
}

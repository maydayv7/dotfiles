{ config, lib, pkgs, ... }:
with lib;
with builtins;
let
  cfg = config.base.enable;
in rec
{
  config = mkIf (cfg == true)
  {
    ## Security Settings ##
    security =
    {
      sudo.extraConfig =
      "
        Defaults pwfeedback
      ";
    };
  };
}

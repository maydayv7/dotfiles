{ config, lib, ... }:
let
  cfg = config.gui.xorg;
in rec
{
  options.gui.xorg.enable = lib.mkOption
  {
    description = "Enable XORG Configuration";
    type = lib.types.bool;
    default = false;
  };

  ## Xorg Configuration ##
  config = lib.mkIf (cfg.enable == true)
  {
    services.xserver =
    {
      enable = true;
      autorun = true;
      layout = "us";

      # Login
      displayManager.autoLogin =
      {
        enable = true;
        user = "nixos";
      };
    };
  };
}

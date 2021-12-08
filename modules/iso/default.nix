{ config, lib, inputs, ... }:
let
  enable = config.iso;
in rec
{
  # Install Media Build Module
  imports = [ ./build.nix ];

  options.iso = lib.mkEnableOption "Enable Install Media Configuration";

  ## Install Media Configuration ##
  config = lib.mkIf enable
  {
    # ISO Creation Settings
    environment.pathsToLink = [ "/libexec" ];
    isoImage =
    {
      makeEfiBootable = true;
      makeUsbBootable = true;
    };
  };
}

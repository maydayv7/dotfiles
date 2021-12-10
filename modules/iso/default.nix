{ config, lib, ... }:
let
  enable = config.iso;
  hostname = config.networking.hostName;
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
      isoBaseName = hostname;
      makeEfiBootable = true;
      makeUsbBootable = true;
    };
  };
}

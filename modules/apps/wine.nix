{ config, lib, pkgs, ... }:
let
  enable = (builtins.elem "wine" config.apps.list);
in
{
  ## Discord Configuration ##
  config = lib.mkIf enable
  {
    # Utilities
    environment.systemPackages = with pkgs;
    [
      wine
      winetricks
    ];
  };
}

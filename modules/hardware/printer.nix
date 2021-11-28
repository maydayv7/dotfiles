{ config, lib, username, pkgs, ... }:
let
  enable = (builtins.elem "printer" config.hardware.support);
in rec
{
  ## Printer Firmware ##
  config = lib.mkIf enable
  {
    # Scanning
    users.users."${username}".extraGroups = [ "scanner" ];
    # hardware.sane.enable = true;

    # Printing
    services.printing =
    {
      enable = true;
      drivers = with pkgs; [ gutenprint cnijfilter2 ];
    };
  };
}

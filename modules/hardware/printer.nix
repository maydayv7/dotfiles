{
  config,
  lib,
  pkgs,
  ...
}: let
  enable = builtins.elem "printer" config.hardware.support;
in {
  ## Printer Firmware ##
  config = lib.mkIf enable {
    # Scanning
    user.groups = ["lp" "scanner"];
    hardware.sane.enable = true;

    # Printing
    services.printing = {
      enable = true;
      drivers = with pkgs; [gutenprint cnijfilter2];
    };
  };
}

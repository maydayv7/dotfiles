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
      drivers = with pkgs; [gutenprint brlaser cnijfilter2];
      extraConf = ''
        DefaultPaperSize A4
      '';
    };

    # Network Print
    services.avahi = {
      enable = true;
      #nssmdns4 = true;
      openFirewall = true;
    };

    #!# Temporary Workaround
    system = {
      nssModules = [pkgs.nssmdns];
      nssDatabases.hosts = with lib;
        mkMerge [
          (mkOrder 900 ["mdns4_minimal [NOTFOUND=return]"])
          (mkOrder 1501 ["mdns4"])
        ];
    };
  };
}

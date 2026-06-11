## Printer Firmware ##
_: {
  flake.modules.nixos.printer = {pkgs, ...}: {
    hardware.sane.enable = true;

    services.printing = {
      enable = true;
      drivers = with pkgs; [
        gutenprint
        brlaser
        cnijfilter2
      ];
      extraConf = ''
        DefaultPaperSize A4
      '';
    };

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}

{ config, pkgs, ... }:
let font = builtins.head config.fonts.fontconfig.defaultFonts.monospace;
in {
  ## Console Configuration ##
  config = {
    # Setup
    console = {
      font = "ter-132n";
      packages = [ pkgs.terminus_font ];
      useXkbConfig = true;
    };

    # TTY
    services.kmscon = {
      enable = true;
      hwRender = true;
      extraConfig = ''
        font-name=${font}
        font-size=14
      '';
    };

    # Essential Utilities
    environment.systemPackages = with pkgs; [
      cryptsetup
      gparted
      inxi
      killall
      mkpasswd
      custom.nixos
      ntfsprogs
      parted
      pciutils
      rsync
      sdparm
      smartmontools
      unrar
      unzip
      usbutils
      wget
    ];
  };
}

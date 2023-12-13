{
  util,
  pkgs,
  ...
}: {
  imports = util.map.modules.list ./.;

  ## Base Configuration ##
  config = {
    # Documentation
    documentation = {
      dev.enable = true;
      man.enable = true;
    };

    # Essential Utilities
    environment.systemPackages = with pkgs; [
      cryptsetup
      gparted
      inxi
      killall
      man-pages
      mkpasswd
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

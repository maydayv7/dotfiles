{ ... }: rec {
  ## XORG Configuration ##
  config = {
    services.xserver = {
      enable = true;
      autorun = true;
      layout = "us";

      # Driver Settings
      videoDrivers = [ "modesetting" ];
      useGlamor = true;
    };
  };
}

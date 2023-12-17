{files, ...}: {
  ## XORG Configuration ##
  config = {
    user.homeConfig.xresources.extraConfig = files.xorg;
    services.xserver = {
      enable = true;
      autorun = true;
      layout = "us";

      # Driver Settings
      videoDrivers = ["modesetting"];
    };
  };
}

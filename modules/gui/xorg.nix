{
  lib,
  files,
  ...
}: {
  options.gui.xorg.enable = lib.mkOption {
    description = "Enable X11 Server Configuration";
    type = lib.types.bool;
    default = true;
  };

  ## X11 Server Configuration ##
  config = {
    user.homeConfig.xresources.extraConfig = files.xorg;
    services.xserver = {
      enable = true;
      autorun = true;

      # Driver Settings
      videoDrivers = lib.mkDefault ["modesetting"];
    };

    # System Specialisation
    specialisation.xorg.configuration = {
      system.nixos.tags = ["xorg"];
      gui.wayland.enable = lib.mkForce false;
    };
  };
}

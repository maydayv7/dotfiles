{
  lib,
  files,
  ...
}: let
  inherit (lib) mkDefault mkForce mkOption types;
in {
  options.gui.xorg.enable = mkOption {
    description = "Enable X11 Server Configuration";
    type = types.bool;
    default = true;
  };

  ## X11 Server Configuration ##
  config = {
    user.homeConfig.xresources.extraConfig = files.xorg;
    services.xserver = {
      enable = true;
      autorun = true;

      # Driver Settings
      videoDrivers = mkDefault ["modesetting"];
    };

    # System Specialisation
    specialisation.xorg.configuration = {
      system.nixos.tags = ["xorg"];
      gui.wayland.enable = mkForce false;
      hardware.vm.android.enable = mkForce false;
    };
  };
}

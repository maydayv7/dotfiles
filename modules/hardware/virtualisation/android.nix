{
  config,
  lib,
  pkgs,
  ...
}: {
  options.hardware.vm.android.enable = lib.mkEnableOption "Enable Android Virtualisation";

  ## Android Virtualisation ##
  config = lib.mkIf config.hardware.vm.android.enable {
    virtualisation.waydroid.enable = true;
    environment.systemPackages = [pkgs.wl-clipboard];

    #!# Run the following command to install the image:
    #!# sudo waydroid init -s GAPPS -f

    # Environment Setup
    user.groups = ["android"];
    users.groups.android = {
      name = "android";
      gid = 1000;
    };
    user.persist.directories = [".local/share/waydroid"];
    environment.persist.directories = [
      {
        directory = "/var/lib/waydroid";
        group = "android";
        mode = "774";
      }
    ];
  };
}

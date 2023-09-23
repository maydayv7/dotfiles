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

    # Environment Setup
    user.groups = ["android"];
    user.persist.directories = [".local/share/waydroid"];
    environment.persist.directories = [
      {
        directory = "/var/lib/waydroid";
        group = "android";
        mode = "664";
      }
    ];
  };
}

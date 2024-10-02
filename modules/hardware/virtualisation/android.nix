{
  config,
  options,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf optional;
in {
  options.hardware.vm.android.enable = mkEnableOption "Enable Android Virtualisation";

  ## Android Virtualisation ##
  config = mkIf config.hardware.vm.android.enable {
    assertions = [
      {
        assertion = config.gui.wayland.enable;
        message = ''
          Wayland support is required
          - Use a DE that supports Wayland
        '';
      }
    ];

    warnings = optional (config.boot.kernelPackages != options.boot.kernelPackages.default) ''
      Android Virtualisation may not work
      - Kernel may not have requisite 'binder' module
      - Use the mainline/LTS kernel for assured support
    '';

    virtualisation.waydroid.enable = true;
    environment.systemPackages = [pkgs.wl-clipboard];

    #!# Run 'waydroid init -s GAPPS -f' to install the image

    # Environment Setup
    users.groups.android = {
      name = "android";
      gid = 1000;
    };

    user = {
      groups = ["android"];
      persist.directories = [".local/share/waydroid"];
    };

    environment.persist.directories = [
      {
        directory = "/var/lib/waydroid";
        group = "android";
        mode = "774";
      }
    ];
  };
}

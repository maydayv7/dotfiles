## Android Virtualisation ##
# ? # Run 'waydroid init -s GAPPS -f' to install system image
_: {
  flake.modules.nixos.android = {
    config,
    options,
    lib,
    pkgs,
    ...
  }: {
    config = {
      warnings = lib.optional (config.boot.kernelPackages != options.boot.kernelPackages.default) ''
        Android Virtualisation may not work
        - Kernel may not have requisite 'binder' module
        - Use the mainline/LTS kernel for assured support
      '';

      virtualisation.waydroid.enable = true;
      environment.systemPackages = [pkgs.wl-clipboard];

      # Environment Setup
      users.groups.android = {
        name = "android";
        gid = 1000;
      };

      environment.persist.directories = [
        {
          directory = "/var/lib/waydroid";
          group = "android";
          mode = "774";
        }
      ];
    };
  };
}

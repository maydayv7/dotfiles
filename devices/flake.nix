{
  lib,
  util,
  inputs,
  ...
}: let
  inherit (inputs) self;
  inherit (util) map pack;
  inherit (builtins) head readFile;
  inherit (import ../modules/configuration.nix {inherit lib inputs;}) build;
in {
  flake = {
    ## Device Configuration ##
    nixosConfigurations = map.modules ./. (name: build (import name));

    ## Virtual Machines ##
    vmConfigurations = with self;
      map.modules ./vm
      (name: import name inputs.wfvm.lib legacyPackages."${head systems}");

    ## Install Media Configuration ##
    installMedia = let
      iso = config:
        build (config
          // {
            format = "iso";
            description = "Install Media";

            kernelModules = ["nvme"];
            kernel = "zfs";
            gui.desktop = config.gui.desktop + "-minimal";

            # Default User
            user = {
              name = "nixos";
              description = "Default User";
              minimal = true;
              shells = null;
              password = readFile ../modules/user/passwords/default;
            };

            # Disabled Modules
            imports = [
              {
                user.home = lib.mkForce {};
                sops.secrets = lib.mkForce {};
              }
            ];
          });

      region = {
        timezone = "Asia/Kolkata";
        locale = "IN";
      };
    in rec {
      default = xfce;
      gnome = iso (region // {gui.desktop = "gnome";});
      xfce = iso (region // {gui.desktop = "xfce";});
    };
  };

  # Install Media Checks
  perSystem = {system, ...}: {
    checks = pack.device self.installMedia "nixos-rebuild";
  };
}

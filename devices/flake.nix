{
  lib,
  util,
  inputs,
  ...
}: let
  inherit (inputs) self;
  inherit (util) build map pack;
  inherit (lib) listToAttrs nameValuePair;
in {
  flake = {
    ## Device Configuration ##
    nixosConfigurations = map.modules ./. (name: build.device (import name));

    ## Install Media Configuration ##
    installMedia =
      listToAttrs (builtins.map (name:
        nameValuePair name (build.device {
          format = "iso";
          description = "Install Media";

          # Region
          timezone = "Asia/Kolkata";
          locale = "IN";

          kernelModules = ["nvme"];
          kernel = "zfs";
          gui.desktop = name + "-iso";

          user = {
            name = "nixos";
            description = "Default User";
            minimal = true;
            shells = null;
            password = builtins.readFile ../users/passwords/default;
          };
        })) (import ../modules/gui/desktop/iso.nix))
      // {default = self.installMedia.gnome;};
  };

  # Install Media Checks
  perSystem = _: {
    checks = pack.device self.installMedia;
  };
}

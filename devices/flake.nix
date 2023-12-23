{
  lib,
  util,
  inputs,
  ...
}: let
  inherit (inputs) self;
  inherit (util) map pack;
  inherit (builtins) head readFile;
  inherit (lib) listToAttrs nameValuePair;
  build = util.build.device {inherit lib inputs;};
in {
  flake = {
    ## Device Configuration ##
    nixosConfigurations = map.modules ./. (name: build (import name));

    ## Install Media Configuration ##
    installMedia =
      listToAttrs (builtins.map (name:
        nameValuePair name (build {
          format = "iso";
          description = "Install Media";

          # Region
          timezone = "Asia/Kolkata";
          locale = "IN";

          kernelModules = ["nvme"];
          kernel = "zfs";
          gui.desktop = name + "-minimal";

          user = {
            name = "nixos";
            description = "Default User";
            minimal = true;
            shells = null;
            password = readFile ../users/passwords/default;
          };
        })) (map.modules.name ../modules/gui/desktop))
      // {default = self.installMedia.xfce;};

    ## Virtual Machines ##
    vmConfigurations = with self;
      map.modules ./vm
      (name: import name inputs.wfvm.lib legacyPackages."${head systems}");
  };

  # Install Media Checks
  perSystem = _: {
    checks = pack.device self.installMedia;
  };
}

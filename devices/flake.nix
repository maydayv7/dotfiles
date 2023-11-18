{
  util,
  inputs,
  ...
}: let
  inherit (inputs) self;
  inherit (util) build map pack;
  inherit (builtins) head;
in {
  flake = {
    ## Device Configuration ##
    nixosConfigurations = map.modules ./. (name: build.device (import name));

    ## Virtual Machines ##
    vmConfigurations = with self;
      map.modules ./vm
      (name: import name inputs.windows.lib legacyPackages."${head systems}");

    ## Install Media Configuration ##
    installMedia = let
      config = {
        timezone = "Asia/Kolkata";
        locale = "IN";
        kernel = "zfs";
      };
    in rec {
      default = xfce;
      gnome = build.iso (config // {gui.desktop = "gnome";});
      xfce = build.iso (config // {gui.desktop = "xfce";});
    };
  };

  # Install Media Checks
  perSystem = {system, ...}: {
    checks = pack.device self.installMedia "nixos-rebuild";
  };
}

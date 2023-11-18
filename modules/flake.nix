{util, ...}: {
  ## Custom Configuration Modules ##
  flake.nixosModules = builtins.removeAttrs (util.map.modules ./. import) ["configuration"];
}

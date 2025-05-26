{ util, ... }:
let
  inherit (util) build map;
in
{
  ## Device Configuration ##
  flake.nixosConfigurations = map.modules ./. (name: build.device (import name));
}

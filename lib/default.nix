{ systems, version, lib, util, inputs, channels, path, files } @ args:
let
  inherit (inputs) self;
in rec
{
  map = import ./map.nix args;
  build = import ./build.nix args;
}

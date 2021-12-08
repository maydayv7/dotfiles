{ systems, version, lib, util, inputs, channels, path, files }:
rec
{
  build = import ./build.nix { inherit systems version lib util inputs channels path files; };
  map = import ./map.nix { inherit systems lib inputs files; };
}

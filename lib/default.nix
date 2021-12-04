{ system, version, lib, util, inputs, pkgs, patches, files, ... }:
rec
{
  build = import ./build.nix { inherit build system version lib util inputs pkgs patches files; };
  map = import ./map.nix { inherit system lib inputs; };
}

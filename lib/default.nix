{ system, version, lib, inputs, pkgs, files, ... }:
rec
{
  build = import ./build.nix { inherit build system version lib inputs pkgs files; };
  map = import ./map.nix { inherit system lib inputs; };
}

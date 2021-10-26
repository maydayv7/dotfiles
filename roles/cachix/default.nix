{ lib, pkgs, ... }:
## Package Cache Configuration using Cachix ##
let
  # Cachix Repos
  folder = ./repos;
  toImport = name: value: folder + ("/" + name);
  filterCaches = key: value: value == "regular" && lib.hasSuffix ".nix" key;
  imports = lib.mapAttrsToList toImport (lib.filterAttrs filterCaches (builtins.readDir folder));
in
{
  inherit imports;
  nix.binaryCaches = [ "https://cache.nixos.org" ];
  environment.systemPackages = with pkgs; [ cachix ];
}

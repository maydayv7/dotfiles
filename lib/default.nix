{ pkgs, home-manager, system, lib, ... }:
rec
{
  user = import ./user.nix { inherit pkgs home-manager lib system; };
  host = import ./host.nix { inherit system pkgs home-manager lib user; };
}

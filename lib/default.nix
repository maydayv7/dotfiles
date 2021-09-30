{ system, lib, inputs, pkgs, home-manager, ... }:
rec
{
  user = import ./user.nix { inherit pkgs home-manager lib system; };
  host = import ./host.nix { inherit system lib user inputs pkgs home-manager; };
}

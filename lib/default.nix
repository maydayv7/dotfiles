{ system, lib, inputs, pkgs, ... }:
rec
{
  user = import ./user.nix { inherit system lib inputs pkgs; };
  host = import ./host.nix { inherit system lib user inputs pkgs; };
}

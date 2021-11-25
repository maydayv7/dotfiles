{ inputs, ... }:
rec
{
  imports =
  [
    ./console.nix
    ./firmware.nix

    # Home Manager Module
    inputs.home.nixosModules.home-manager
  ];
}

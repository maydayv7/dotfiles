{ inputs, ... }:
{
  # Custom Install Media Configuration Modules
  imports =
  [
    ../base
    ../gui
    ../scripts
    ./packages
    ./user

    # Install Media Build Module
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"
  ];
}

{ inputs, ... }:
rec
{
  imports =
  [
    ./user.nix

    # Install Media Build Module
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"
  ];
}

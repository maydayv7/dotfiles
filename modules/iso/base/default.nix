{ lib, inputs, ... }:
rec
{
  imports =
  [
    ./firmware
    ./user

    # Install Media Build Module
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"
  ];

  options.base.enable = lib.mkOption
  {
    description = "Base System Configuration";
    type = lib.types.bool;
    default = true;
  };
}

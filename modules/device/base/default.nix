{ lib, ... }:
rec
{
  imports =
  [
    ./boot
    ./cachix
    ./firmware
    ./nix
    ./security
    ./shell
  ];

  options.base.enable = lib.mkOption
  {
    description = "Base System Configuration";
    type = lib.types.bool;
    default = true;
  };
}

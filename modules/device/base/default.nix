{ lib, ... }:
rec
{
  imports =
  [
    ./cachix
    ./firmware
    ./nix
    ./security
    ./shell
  ];

  options.base.enable = lib.mkOption
  {
    description = "Base Device Configuration";
    type = lib.types.bool;
    default = true;
  };
}

{ config, lib, ... }:
rec
{
  imports =
  [
    ./boot.nix
    ./console.nix
    ./packager.nix
    ./user.nix
  ];

  options.device = lib.mkOption
  {
    description = "Device Specific Configuration";
    type = lib.types.enum [ "PC" "ISO" ];
  };
}

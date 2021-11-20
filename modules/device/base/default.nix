{ config, lib, ... }:
rec
{
  imports =
  [
    ./boot.nix
    ./firmware.nix
    ./nix.nix
    ./shell.nix
    ./user.nix
  ];

  options =
  {
    device.enable = lib.mkOption
    {
      description = "Base Device Configuration";
      type = lib.types.bool;
      default = false;
    };

    iso.enable = lib.mkOption
    {
      description = "Install Media Configuration";
      type = lib.types.bool;
      default = false;
    };
  };
}

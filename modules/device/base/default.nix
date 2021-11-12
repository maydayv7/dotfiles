{ config, lib, ... }:
rec
{
  imports =
  [
    ./firmware
    ./iso
    ./nix
    ./shell
    ./user
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

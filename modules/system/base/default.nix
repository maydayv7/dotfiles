[
  ({ lib, ... }:
  rec
  {
    options.base.enable = lib.mkOption
    {
      description = "Base System Configuration";
      type = lib.types.bool;
      default = true;
    };
  })

  ./boot
  ./cachix
  ./firmware
  ./networking
  ./nix
  ./security
  ./shell
]

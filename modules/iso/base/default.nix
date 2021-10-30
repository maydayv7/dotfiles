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

  ./firmware
  ./networking
  ./nix
  ./user
]

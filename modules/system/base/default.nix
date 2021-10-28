[
  ({ config, lib, ... }:
  with lib;
  rec
  {
    options.base.enable = mkOption
    {
      type = types.bool;
      description = "Base System Configuration";
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

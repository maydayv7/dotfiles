{ lib, ... }:
rec
{
  imports =
  [
    ./filesystem.nix
    ./firmware.nix
    ./mobile.nix
    ./ssd.nix
    ./virtualisation.nix
  ];

  options.hardware.cores = lib.mkOption
  {
    description = "Number of CPU Cores";
    type = lib.types.int;
  };
}

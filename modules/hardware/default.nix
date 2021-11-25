{ lib, ... }:
rec
{
  imports =
  [
    ./boot.nix
    ./filesystem.nix
    ./mobile.nix
    ./ssd.nix
    ./virtualisation.nix
  ];

  options.hardware =
  {
    cores = lib.mkOption
    {
      description = "Number of CPU Cores";
      type = lib.types.int;
      default = 4;
    };

    support = lib.mkOption
    {
      description = "List of Additional Supported Hardware";
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };
}

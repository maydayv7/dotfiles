{ lib, ... }:
let
  inherit (lib) mkOption types;
in rec
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
    boot = mkOption
    {
      description = "Supported Boot Firmware";
      type = types.enum [ "mbr" "efi" ];
      default = "mbr";
    };

    cores = mkOption
    {
      description = "Number of CPU Cores";
      type = types.int;
      default = 4;
    };

    support = mkOption
    {
      description = "List of Additional Supported Hardware";
      type = types.listOf types.str;
      default = [ ];
    };
  };
}

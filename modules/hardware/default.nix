{ lib, ... }:
let inherit (lib) mkOption types;
in rec {
  imports = [
    ./boot.nix
    ./filesystem.nix
    ./mobile.nix
    ./printer.nix
    ./virtualisation.nix
  ];

  options.hardware = {
    cores = mkOption {
      description = "Number of CPU Cores";
      type = types.int;
      default = 4;
    };

    modules = mkOption {
      description = "Additional Hardware Configuration Modules";
      type = types.attrs;
      default = { };
    };

    support = mkOption {
      description = "List of Additional Supported Hardware";
      type = types.listOf types.str;
      default = [ ];
    };
  };
}

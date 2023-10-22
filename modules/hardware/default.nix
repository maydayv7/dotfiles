{lib, ...}: let
  inherit (lib) mkOption types util;
in {
  imports = util.map.module ./.;

  options.hardware = with types; {
    cores = mkOption {
      description = "Number of CPU Cores";
      type = int;
      default = 4;
    };

    modules = mkOption {
      description = "List of Modules imported from 'inputs.hardware'";
      type = listOf str;
      default = [];
    };

    support = mkOption {
      description = "List of Additional Supported Hardware";
      type = listOf (enum (util.map.module' ./.));
      default = [];
    };
  };
}

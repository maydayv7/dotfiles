{
  lib,
  util,
  ...
}: let
  inherit (util.map) modules;
  inherit (lib) mkOption types;
in {
  imports = modules.list ./.;

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
      type = listOf (enum (modules.name ./.));
      default = [];
    };
  };
}

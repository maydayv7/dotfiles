{
  lib,
  util,
  ...
}: let
  inherit (util.map) modules;
  inherit (lib) mkOption types;
in {
  imports = modules.list ./.;

  options.apps.list = mkOption {
    description = "List of Enabled Applications";
    type = types.listOf (types.enum (modules.name ./.));
    default = [];
  };
}

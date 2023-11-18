{
  lib,
  util,
  ...
}: let
  inherit (lib) mkOption types;
in {
  imports = util.map.module ./.;

  options.apps.list = mkOption {
    description = "List of Enabled Applications";
    type = types.listOf (types.enum (util.map.module' ./.));
    default = [];
  };
}

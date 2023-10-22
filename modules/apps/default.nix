{lib, ...}: let
  inherit (lib) mkOption types util;
in {
  imports = util.map.module ./.;

  options.apps.list = mkOption {
    description = "List of Enabled Applications";
    type = types.listOf (types.enum (util.map.module' ./.));
    default = [];
  };
}

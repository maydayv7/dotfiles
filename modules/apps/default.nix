{lib, ...}:
with {inherit (lib) mkOption types util;}; {
  imports = util.map.module ./.;

  options.apps.list = mkOption {
    description = "List of Enabled Applications";
    type = types.listOf (types.enum (util.map.module' ./.));
    default = [];
  };
}

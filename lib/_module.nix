## Custom Library Functions ##
{lib, ...}: {
  options.util = lib.mkOption {
    type = lib.types.anything;
    readOnly = true;
    description = "Custom utility library functions";
  };

  config.util = {
    map = import ./map.nix lib;
    build = import ./build.nix lib;
    types = import ./types.nix lib;
  };
}

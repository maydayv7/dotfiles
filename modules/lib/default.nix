## Custom Library Functions ##
{lib, ...}: {
  options.util = lib.mkOption {
    type = lib.types.anything;
    readOnly = true;
    description = "Custom utility library functions";
  };

  config.util = {
    map = import ./_map.nix lib;
    build = import ./_build.nix lib;
    types = import ./_types.nix lib;
  };
}

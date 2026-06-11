## Custom Library Functions ##
{lib, ...}: let
  map = import ./map.nix lib;
  build = import ./build.nix lib;
in {
  options.util = lib.mkOption {
    type = lib.types.anything;
    readOnly = true;
    description = "Custom utility library functions";
  };

  config.util = {
    inherit map build;
  };
}

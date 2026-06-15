## Custom Library Functions ##
{lib, ...}: let
  map = import ./map.nix lib;
  build = import ./build.nix lib;

  # Flake configurations type
  types.configuration = lib.types.submodule {
    options = {
      module = lib.mkOption {
        type = lib.types.deferredModule;
      };
      system = lib.mkOption {
        type = lib.types.str;
        default = "x86_64-linux";
      };
    };
  };
in {
  options.util = lib.mkOption {
    type = lib.types.anything;
    readOnly = true;
    description = "Custom utility library functions";
  };

  config.util = {
    inherit map build types;
  };
}

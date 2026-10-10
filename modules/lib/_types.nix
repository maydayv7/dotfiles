## Custom Types ##
lib: {
  # Flake configurations
  configuration = lib.types.submodule {
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
}

## Custom Types ##
lib: {
  # Flake configurations
  configuration = lib.types.submodule {
    options = {
      module = lib.mkOption {
        type = lib.types.deferredModule;
      };

      defaults = lib.mkOption {
        description = "Import core system modules";
        type = lib.types.bool;
        default = true;
      };

      system = lib.mkOption {
        type = lib.types.str;
        default = "x86_64-linux";
      };
    };
  };
}

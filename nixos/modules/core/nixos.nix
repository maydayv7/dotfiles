{ lib, config, inputs, ... }:
{
  options.configurations.nixos = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options.module = lib.mkOption {
          type = lib.types.deferredModule;
        };
      }
    );
    default = { };
  };

  config.flake = {
    nixosConfigurations = lib.mapAttrs (
      name:
      { module }:
      lib.nixosSystem {
        modules = [
          module
          { networking.hostName = name; }
        ];
      }
    ) config.configurations.nixos;

    checks =
      lib.mkMerge (
        lib.mapAttrsToList (
          name: nixos: {
            ${nixos.config.nixpkgs.hostPlatform.system} = {
              "configurations:nixos:${name}" = nixos.config.system.build.toplevel;
            };
          }
        ) config.flake.nixosConfigurations
      );
  };
}

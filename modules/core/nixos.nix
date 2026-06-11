{
  lib,
  config,
  ...
}: {
  options.configurations.nixos = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options = {
          module = lib.mkOption {
            type = lib.types.deferredModule;
          };
          system = lib.mkOption {
            type = lib.types.str;
            default = "x86_64-linux";
          };
        };
      }
    );
    default = {};
  };

  config.flake = {
    nixosConfigurations =
      lib.mapAttrs (
        name: {
          module,
          system,
        }:
          lib.nixosSystem {
            modules = [
              module
              {networking.hostName = name;}
              {nixpkgs.pkgs = config.flake.legacyPackages.${system};}
            ];
          }
      )
      config.configurations.nixos;

    checks = lib.mkMerge (
      lib.mapAttrsToList (
        name: {system, ...}: {
          ${system} = {
            "configurations:nixos:${name}" =
              config.flake.nixosConfigurations.${name}.config.system.build.toplevel;
          };
        }
      )
      config.configurations.nixos
    );
  };
}

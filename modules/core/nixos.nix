{
  lib,
  config,
  ...
}: let
  inherit (config) util flake;
in {
  options.configurations.nixos = lib.mkOption {
    type = lib.types.lazyAttrsOf util.types.configuration;
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
            modules =
              [
                module
                {
                  networking.hostName = name;
                  nixpkgs.pkgs = flake.legacyPackages.${system};
                }
              ]
              ++
              # Default Modules
              util.map.array [
                "base"
                "cpu"
                "gpu"
                "nix"
                "user"
                "secrets"
                "shell"
                "theme"
                "fonts"
              ]
              flake.modules.nixos;
          }
      )
      config.configurations.nixos;

    checks = lib.mkMerge (
      lib.mapAttrsToList (
        name: {system, ...}: {
          ${system} = {
            "configurations:nixos:${name}" =
              flake.nixosConfigurations.${name}.config.system.build.toplevel;
          };
        }
      )
      config.configurations.nixos
    );
  };
}

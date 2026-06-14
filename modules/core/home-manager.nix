{
  lib,
  config,
  inputs,
  ...
}: let
  inherit (config) util;
  inherit (config.flake) files modules;
in {
  options.configurations.homeManager = lib.mkOption {
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

  config.flake.homeConfigurations =
    lib.mapAttrs (
      name: {
        module,
        system,
      }:
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = config.flake.legacyPackages.${system};
          modules =
            [
              module

              # Compatibility
              inputs.stylix.homeModules.stylix
              (
                {lib, ...}: {
                  stylix.base16Scheme = lib.mkDefault files.colors.catppuccin;
                }
              )
              (
                {lib, ...}: {
                  options.home.persistence = lib.mkOption {
                    type = lib.types.attrsOf lib.types.anything;
                    default = {};
                  };
                }
              )
            ]
            ++
            # Default Modules
            util.map.array [
              "base"
              "user"
              "nix"
              "shell"
              "theme"
            ]
            modules.homeManager;
        }
    )
    config.configurations.homeManager;
}

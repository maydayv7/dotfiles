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
    type = lib.types.lazyAttrsOf util.types.configuration;
    default = {};
  };

  config.flake.homeConfigurations =
    lib.mapAttrs (
      name: {
        module,
        system,
        defaults,
      }:
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = config.flake.legacyPackages.${system};
          extraSpecialArgs = {inherit inputs;};
          modules =
            [
              module

              # Compatibility
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
            lib.optionals defaults [
              inputs.stylix.homeModules.stylix
              ({lib, ...}: {stylix.base16Scheme = lib.mkDefault files.colors.catppuccin;})
              modules.homeManager.default
            ];
        }
    )
    config.configurations.homeManager;
}

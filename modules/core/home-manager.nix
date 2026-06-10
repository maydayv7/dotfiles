{
  lib,
  config,
  inputs,
  ...
}: let
  inherit (config.flake) files;
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
          modules = [
            module
            # Stylix theming (auto-imported via the NixOS module when integrated)
            inputs.stylix.homeModules.stylix
            # Standalone has no system wallpaper: provide a default colour scheme
            (
              {lib, ...}: {
                stylix.base16Scheme = lib.mkDefault files.colors.catppuccin;
              }
            )
            # Standalone home-manager has no ephemeral root: provide a no-op
            # 'home.persistence' so the 'home.persist' alias resolves (impermanence's
            # home-manager module is only auto-imported via the NixOS module)
            (
              {lib, ...}: {
                options.home.persistence = lib.mkOption {
                  type = lib.types.attrsOf lib.types.anything;
                  default = {};
                };
              }
            )
          ];
        }
    )
    config.configurations.homeManager;
}

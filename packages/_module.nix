## Package Configuration ##
{
  config,
  inputs,
  lib,
  ...
}: let
  umap = import ../modules/lib/_map.nix lib;
  inherit (builtins) any attrValues isPath;
in {
  perSystem = {
    self',
    system,
    lib,
    inputs',
    pkgs,
    ...
  }:
    rec {
      _module.args.pkgs = legacyPackages;
      legacyPackages = with inputs; let
        nixpkgsConfig = import ./_config.nix;
      in
        import (config.flake.patchedPkgs system) {
          inherit system;
          config = nixpkgsConfig;

          overlays =
            (attrValues config.flake.overlays or {})
            ++ [
              (final: _: {
                custom = config.flake.packages."${system}" or {};
                unstable = import unstable {
                  inherit system;
                  config = nixpkgsConfig;
                };

                disko = disko.packages."${system}";
                llm = llm.packages."${system}";
                spicetify = spicetify.legacyPackages."${system}";
              })
              minecraft.overlay
              vscode.overlays.default
            ];
        };
    }
    // (
      let
        call = rec {
          __functor = _: name: pkg name {};
          pkg = name: args: pkgs.callPackage name ({inherit lib pkgs;} // {inherit (config) util;} // args);
          script = name:
            pkg name {
              inherit inputs;
              inherit (config.flake) files;
            };
        };
      in {
        packages =
          umap.modules ../packages call // umap.modules ../scripts call.script // inputs'.proprietary.packages;
        apps =
          umap.modules ../scripts (
            name: let
              drv = call.script name;
            in {
              type = "app";
              program = lib.getExe drv;
              meta = drv.meta or {};
            }
          )
          // {
            default = self'.apps.os;
          };
      }
    );

  flake = {
    patchedPkgs = system: let
      src = inputs.nixpkgs;
      patches = umap.patches ./patches;
      pkgs' = import src {inherit system;};
    in
      if !(any isPath patches)
      then src
      else
        pkgs'.applyPatches {
          inherit src patches;
          name = "nixpkgs-patched-${src.shortRev}";
        };

    overlays = umap.modules ./overlays import;
  };
}

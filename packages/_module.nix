## Package Configuration ##
{
  config,
  inputs,
  lib,
  ...
}: let
  map = import ../lib/map.nix lib;
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
                stagit-fork = stagit.packages."${system}".default;
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
          map.modules ../packages call // map.modules ../scripts call.script // inputs'.proprietary.packages;
        apps =
          map.modules ../scripts (
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
      patches = map.patches ./patches;
      pkgs' = import src {inherit system;};
    in
      if !(any isPath patches)
      then src
      else
        pkgs'.applyPatches {
          inherit src patches;
          name = "nixpkgs-patched-${src.shortRev}";
        };

    overlays = map.modules ./overlays import;
  };
}

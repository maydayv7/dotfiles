{
  lib,
  util,
  inputs,
  ...
}: let
  inherit (util) map;
  inherit (builtins) any attrValues isPath;
in {
  ## Package Configuration ##
  perSystem = {
    self',
    system,
    lib,
    inputs',
    pkgs,
    ...
  }:
    rec {
      # Default Package Channel
      _module.args.pkgs = legacyPackages;
      legacyPackages = channels.stable;

      # Package Channels
      channels = with inputs; let
        # Repository Configuration
        config = import ../modules/nix/config.nix;

        # Package Overrides
        overlays =
          (attrValues self.overlays or {})
          ++ [
            vsppuccin.overlays.default
            (_: _: {
              custom = self.packages."${system}";

              code = vscode.extensions."${system}";
              gaming = gaming.packages."${system}";
              wine = windows.packages."${system}";
              hyprworld =
                hyprland.packages."${system}"
                // hyprland-plugins.packages."${system}"
                // hycov.packages."${system}"
                // hyprspace.packages."${system}"
                // hyprsplit.packages."${system}";
            })
          ];
      in {
        stable = let
          src = stable;
          patches = map.patches ./patches;
          pkgs' = import src {inherit system;};
        in
          (
            if !(any isPath patches)
            then import src
            else
              import (pkgs'.applyPatches {
                inherit src patches;
                name = "nixpkgs-patched-${src.shortRev}";
              })
          ) {
            inherit system config;
            overlays = overlays ++ [(_: _: {inherit (channels) unstable;})];
          };

        unstable = import unstable {
          inherit system config;
          overlays = overlays ++ [(_: _: {inherit (channels) stable;})];
        };
      };
    }
    // (let
      # Package Calling Function
      call = rec {
        __functor = _: name: pkg name {};
        pkg = name: args: pkgs.callPackage name ({inherit lib util pkgs;} // args);
        script = name:
          pkg name {
            inherit inputs;
            inherit (inputs.self) files;
          };
      };
    in {
      # Custom Packages
      apps =
        map.modules ../scripts (name: inputs.utils.lib.mkApp {drv = call.script name;})
        // {default = self'.apps.nixos;};
      packages =
        map.modules ./. call
        // map.modules ../scripts call.script
        // inputs'.proprietary.packages;
    });

  # Channel Module
  imports = [
    (_:
      with lib;
        inputs.framework.lib.mkTransposedPerSystemModule {
          name = "channels";
          option = mkOption {
            type = with types; attrsOf (lazyAttrsOf raw);
            default = {nixpkgs = import inputs.nixpkgs {};};
            description = "Set of Package Channels";
          };
          file = ./flake.nix;
        })
  ];

  # Package Overrides
  flake.overlays = map.modules ./overlays import;
}

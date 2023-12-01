{
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
  }: (let
    # Package Calling Function
    call = name:
      pkgs.callPackage name {
        inherit lib util inputs pkgs;
        inherit (inputs.self) files;
      };
  in rec {
    # Default Package Channel
    _module.args.pkgs = legacyPackages;
    legacyPackages = with inputs; let
      src = nixpkgs;
      patches = map.patches ./patches;
      pkgs' = import src {inherit system;};
    in
      if !(any isPath patches)
      then import src
      else
        import (pkgs'.applyPatches {
          inherit src patches;
          name = "nixpkgs-patched-${src.shortRev}";
        }) {
          inherit system;
          config = import ../modules/nix/config.nix;
          overlays =
            [nur.overlay]
            ++ (attrValues self.overlays or {})
            ++ [
              (final: prev: {
                custom = self.packages."${system}";
                unstable = import unstable {inherit system;};

                wine = wine.packages."${system}";
                gaming = gaming.packages."${system}";
                generators = generators.packages."${system}".default;
              })
            ];
        };

    # Custom Packages
    apps =
      map.modules ../scripts (name: inputs.utils.lib.mkApp {drv = call name;})
      // {default = self'.apps.nixos;};
    packages =
      map.modules ./. call
      // map.modules ../scripts call
      // inputs'.proprietary.packages;
  });

  # Package Overrides
  flake.overlays = map.modules ./overlays import;
}

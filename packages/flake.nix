{
  util,
  inputs,
  ...
}: let
  inherit (util) map;
  inherit (builtins) any isPath;
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
    call = rec {
      __functor = _: name: pkg name {};
      pkg = name: args: pkgs.callPackage name ({inherit lib util pkgs;} // args);
      script = name:
        pkg name {
          inherit inputs;
          inherit (inputs.self) files;
        };
    };
  in rec {
    # Default Package Channel
    _module.args.pkgs = legacyPackages;
    legacyPackages = with inputs; let
      src = nixpkgs;
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
        inherit system;
        config = import ../modules/nix/config.nix;
        overlays = [
          nur.overlay
          (final: prev: {
            nixFlakes = prev.nixVersions.nix_2_19;

            custom = self.packages."${system}";
            unstable = import unstable {inherit system;};

            chaotic = chaotic.packages."${system}";
            code = vscode.extensions."${system}";
            gaming = gaming.packages."${system}";
            wine = windows.packages."${system}";
          })
        ];
      };

    # Custom Packages
    apps =
      map.modules ../scripts (name: inputs.utils.lib.mkApp {drv = call.script name;})
      // {default = self'.apps.nixos;};
    packages =
      map.modules ./. call
      // map.modules ../scripts call.script
      // inputs'.proprietary.packages;
  });
}

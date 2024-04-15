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
    # Repository Configuration
    config = import ../modules/nix/config.nix;

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
      ) rec {
        inherit system config;

        overlays = [
          vsppuccin.overlays.default
          (pkg: _: {
            nixFlakes = pkg.unstable.nixVersions.nix_2_20;

            custom = self.packages."${system}";
            unstable = import unstable {inherit system config;};

            code = vscode.extensions."${system}";
            gaming = gaming.packages."${system}";
            wine = windows.packages."${system}";
            wayworld =
              wayland.packages."${system}"
              // hyprspace.packages."${system}"
              // hyprland-plugins.packages."${system}"
              // hyprland.packages."${system}";
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

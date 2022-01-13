{ systems, lib, inputs, ... }:
let
  inherit (inputs) self nixpkgs;
  inherit (lib) flatten hasSuffix mapAttrsToList nameValuePair;
  inherit (builtins) attrValues isPath listToAttrs map readDir readFile;
in rec {
  ## Builder Functions ##
  eachSystem = func:
    listToAttrs (map (name: nameValuePair name (func name)) systems);

  # Configuration Builders
  device = self.nixosModule.config;
  iso = config:
    self.nixosModule.config (config // {
      description = "Install Media";
      kernelModules = [ "nvme" ];

      # Default User
      user = {
        name = "nixos";
        description = "Default User";
        autologin = true;
        password = readFile ../modules/user/passwords/default;
      };

      imports = [
        # Build Module
        "${nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"

        ({
          # `.iso` Creation Settings
          isoImage = {
            makeEfiBootable = true;
            makeUsbBootable = true;
          };
        })
      ];
    });

  # Package Channels Builder
  channel = src: overlays: patches':
    let
      patches = if isPath patches' then
        flatten (mapAttrsToList (name: type:
          if type == "regular" && hasSuffix ".diff" name then
            patches' + "/${name}"
          else
            null) (readDir patches'))
      else
        patches';
    in eachSystem (system:
      (if patches == [ ] then
        import src
      else
        import (src.legacyPackages.${system}.applyPatches {
          inherit src patches;
          name = "patched-input-${src.shortRev}";
        })) {
          inherit system;
          overlays = overlays ++ (attrValues self.overlays or { }) ++ [
            (final: prev:
              {
                custom = self.packages.${system};
              } // self.channels.${system})
          ];
          config = {
            allowAliases = true;
            allowBroken = true;
            allowUnfree = true;
          };
        });
}

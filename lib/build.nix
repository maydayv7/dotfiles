{ systems, lib, inputs, ... }:
let
  inherit (inputs) self nixpkgs;
  inherit (builtins) attrValues isPath listToAttrs map readDir toString;
  inherit (lib) flatten hasSuffix mapAttrsToList nameValuePair;
in rec {
  ## Builder Functions ##
  eachSystem = func:
    listToAttrs (map (name: nameValuePair name (func name)) systems);

  # Configuration Builders
  device = self.nixosModule.config;
  iso = config:
    self.nixosModule.config (config // {
      description = "Install Media";
      imports = [
        # Build Module
        "${nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"

        ({
          # `.iso` Creation Settings
          environment.pathsToLink = [ "/libexec" ];
          isoImage = {
            makeEfiBootable = true;
            makeUsbBootable = true;
          };
        })
      ];
    });

  # Package Channels Builder
  channel = src: overlays: patches:
    eachSystem (system:
      (if patches == [ ] then
        import src
      else
        import (src.legacyPackages."${system}".applyPatches {
          inherit src;
          name = "patched-input-${src.shortRev}";
          patches = if isPath patches then
            flatten (mapAttrsToList (name: type:
              if type == "regular" && hasSuffix ".diff" name then
                patches + "/${name}"
              else
                null) (readDir patches))
          else
            patches;
        })) {
          inherit system;
          overlays = overlays ++ (attrValues self.overlays) ++ [
            self.overlay
            (final: prev:
              {
                custom = self.packages."${system}";
              } // self.channels."${system}")
          ];
          config = {
            allowAliases = true;
            allowUnfree = true;
          };
        });
}

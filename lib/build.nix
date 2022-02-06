{ self, platforms, lib, ... }:
let
  inherit (builtins) any attrValues isPath listToAttrs map mapAttrs readFile;
  inherit (lib)
    concatMapStrings nameValuePair recursiveUpdate remove splitString take util;
in rec {
  ## Builder Functions ##
  each = attr: func:
    listToAttrs (map (name: nameValuePair name (func name)) attr);

  # Configuration Builders
  device = self.nixosModule.config;
  iso = config:
    self.nixosModule.config (config // {
      format = "iso";
      description = "Install Media";
      kernelModules = [ "nvme" ];

      # Default User
      user = {
        name = "nixos";
        description = "Default User";
        minimal = true;
        recovery = false;
        password = readFile ../modules/user/passwords/default;
      };
    });

  # Package Channels Builder
  channel = src: overlays: patch:
    let patches = util.map.patches patch;
    in each platforms (system:
      let pkgs = src.legacyPackages."${system}";
      in (if !(any isPath patches) then
        import src
      else
        import (pkgs.applyPatches {
          inherit src patches;
          name = "Patched-Input_${src.shortRev}";
        })) {
          inherit system;
          overlays = overlays ++ (attrValues self.overlays or { }) ++ [
            (final: prev:
              recursiveUpdate {
                custom = self.packages."${system}";
                apps = mapAttrs (name: value:
                  pkgs.symlinkJoin {
                    inherit name;
                    paths = [
                      (concatMapStrings (x: "/" + x)
                        (take 3 (remove "" (splitString "/" value.program))))
                    ];
                  }) self.apps."${system}";
              } self.channels."${system}")
          ];

          config = {
            allowAliases = true;
            allowBroken = false;
            allowUnfree = true;
          };
        });
}

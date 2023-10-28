{
  self,
  systems,
  lib,
  ...
}: let
  inherit (builtins) attrValues concatStringsSep filter hasAttr listToAttrs map readFile;
  inherit (lib) flatten hasPrefix mapAttrsToList mkForce nameValuePair recursiveUpdate splitString;
in rec {
  ## Builder Functions ##
  each = attr: func:
    listToAttrs (map (name: nameValuePair name (func name)) attr);

  # Configuration Builders
  device = self.nixosModules.default.config;
  iso = config:
    device (config
      // {
        format = "iso";
        description = "Install Media";
        kernelModules = ["nvme"];
        gui.desktop = config.gui.desktop + "-minimal";

        # Default User
        imports = [{user.home = mkForce {};}];
        user = {
          name = "nixos";
          description = "Default User";
          minimal = true;
          shells = null;
          password = readFile ../modules/user/passwords/default;
        };
      });

  # Package Channels Builder
  channel = src: overlays:
    each systems (system: let
      pkgs = src.legacyPackages."${system}";
    in
      import src {
        inherit system;
        config = import ../modules/nix/config.nix;
        overlays =
          overlays
          ++ (attrValues self.overlays or {})
          ++ [
            (final: prev:
              recursiveUpdate {custom = self.packages."${system}";}
              self.channels."${system}")
          ];
      });

  # Mime Types Handler
  mime = values: option:
    listToAttrs (flatten (mapAttrsToList (name: types:
      if hasAttr name option
      then map (type: nameValuePair type option."${name}") types
      else [])
    values));

  # Script Builder
  script = file:
    concatStringsSep "\n"
    ((filter (line: line != "" && !(hasPrefix "#!" line)))
      (splitString "\n" (readFile file)));
}

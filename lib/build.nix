{
  lib,
  inputs,
  ...
}: let
  inherit (lib) flatten hasPrefix mapAttrsToList mkForce nameValuePair splitString;
  inherit (builtins) concatStringsSep filter hasAttr listToAttrs map readFile;
in rec {
  ## Builder Functions ##
  each = attr: func:
    listToAttrs (map (name: nameValuePair name (func name)) attr);

  # Configuration Builders
  device = (import ../modules/configuration.nix {inherit lib inputs;}).build;
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

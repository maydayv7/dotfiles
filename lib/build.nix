lib: let
  inherit (lib) flatten hasPrefix mapAttrsToList nameValuePair splitString;
  inherit (builtins) concatStringsSep filter hasAttr listToAttrs map readFile;
in rec {
  ## Builder Functions ##
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

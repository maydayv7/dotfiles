{lib, ...}: let
  inherit (builtins) hasAttr listToAttrs map;
  inherit (lib) flatten mapAttrsToList nameValuePair;
in rec {
  ## XDG Helper Functions ##
  # Mime Types Handler
  mime = values: option:
    listToAttrs (flatten (mapAttrsToList (name: types:
      if hasAttr name option
      then map (type: nameValuePair type option."${name}") types
      else [])
    values));
}

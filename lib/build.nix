lib: let
  inherit (lib) flatten hasPrefix mapAttrsToList nameValuePair replaceStrings splitString;
  inherit (builtins) concatStringsSep filter hasAttr listToAttrs map readFile;
in {
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

  # Base16 Color Substituter
  color = colors: file:
    replaceStrings ["@base00" "@base01" "@base02" "@base03" "@base04" "@base05" "@base06" "@base07" "@base08" "@base09" "@base0A" "@base0B" "@base0C" "@base0D" "@base0E" "@base0F"]
    (with colors; [base00 base01 base02 base03 base04 base05 base06 base07 base08 base09 base0A base0B base0C base0D base0E base0F])
    file;
}

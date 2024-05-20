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

  # Theme Substituter
  theme = {
    accent ? "base0D",
    colors ? null,
    fonts ? null,
    file,
  }: let
    color = ["@accent" "@white" "@base00" "@base01" "@base02" "@base03" "@base04" "@base05" "@base06" "@base07" "@base08" "@base09" "@base0A" "@base0B" "@base0C" "@base0D" "@base0E" "@base0F"];
    color' = with colors; [colors."${accent}" "FFFFFF" base00 base01 base02 base03 base04 base05 base06 base07 base08 base09 base0A base0B base0C base0D base0E base0F];
    font = ["@font" "@monospace"];
    font' = with fonts; [sansSerif.name monospace.name];
  in
    if (colors != null && fonts != null)
    then replaceStrings (color ++ font) (color' ++ font') file
    else if (colors != null)
    then replaceStrings color color' file
    else if (fonts != null)
    then replaceStrings font font' file
    else throw "One of 'colors' or 'fonts' must be declared";
}

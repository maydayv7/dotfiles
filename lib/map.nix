{lib, ...}: let
  inherit
    (builtins)
    attrNames
    attrValues
    foldl'
    isPath
    pathExists
    readDir
    toString
    typeOf
    ;

  inherit
    (lib)
    flatten
    filterAttrs
    forEach
    getAttrFromPath
    hasPrefix
    hasSuffix
    id
    mapAttrs'
    mapAttrsToList
    mkIf
    nameValuePair
    removeSuffix
    ;
in rec {
  ## Mapping Functions ##
  array = list: func: forEach list (name: getAttrFromPath [name] func);
  filter = name: func: attrs: filterAttrs name (mapAttrs' func attrs);
  list = func: foldl' (x: y: x + y + " ") "" (attrNames func);

  ## Files Map
  # Top Level
  files = dir: func: ext: file dir func ext (_: true);
  file = dir: func: ext: cond:
    filter (name: type: type != null && !(hasPrefix "_" name)) (name: type: let
      path = "${toString dir}/${name}";
    in
      if
        (type == "directory" || type == "symlink")
        && (
          if (ext == ".nix")
          then pathExists "${path}/default.nix"
          else true
        )
      then nameValuePair name (func path)
      else if
        type
        == "regular"
        && (
          if (ext == ".nix")
          then name != "default.nix"
          else true
        )
        && hasSuffix ext name
        && (cond path)
      then nameValuePair (removeSuffix ext name) (func path)
      else nameValuePair "" null) (readDir dir);

  # Recursive
  files' = dir: func: ext: file' dir func ext (_: true);
  file' = dir: func: ext: cond:
    filter (name: type: type != null && !(hasPrefix "_" name)) (name: type: let
      path = "${toString dir}/${name}";
    in
      if (type == "directory" || type == "symlink")
      then nameValuePair name (file' path func)
      else if
        type
        == "regular"
        && (
          if (ext == ".nix")
          then name != "default.nix"
          else true
        )
        && hasSuffix ext name
        && (cond path)
      then nameValuePair (removeSuffix ext name) (func path)
      else nameValuePair "" null) (readDir dir);

  # Package Patches
  patches = patch:
    if isPath patch
    then
      flatten (mapAttrsToList (name: type:
        if
          type
          == "regular"
          && (hasSuffix ".diff" name || hasSuffix ".patch" name)
        then patch + "/${name}"
        else null) (readDir patch))
    else patch;

  # Module Imports
  checkAttr = name: let
    file = import name;
  in
    typeOf file == "set" || typeOf file == "lambda";
  module = dir: attrValues (modules dir id);
  module' = dir: attrNames (modules dir id);
  modules = dir: func: file dir func ".nix" checkAttr;
  modules' = dir: func: file' dir func ".nix" checkAttr;

  # 'sops' Encrypted Secrets
  secrets = dir: neededForUsers:
    filter (name: type: type != null && !(hasPrefix "_" name)) (name: type:
      if type == "regular" && hasSuffix ".secret" name
      then
        nameValuePair name {
          sopsFile = dir + "/${name}";
          format = "binary";
          inherit neededForUsers;
        }
      else nameValuePair "" null) (readDir dir);
}

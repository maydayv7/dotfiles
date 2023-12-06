lib: let
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
    nameValuePair
    removeSuffix
    ;

  # Import Checks
  checkName = name: type: type != null && !(hasPrefix "_" name);
  checkAttr = name: let
    file = import name;
  in
    typeOf file == "set" || typeOf file == "lambda";
in rec {
  ## Mapping Functions ##
  array = list: func: forEach list (name: getAttrFromPath [name] func);
  filter = name: func: attrs: filterAttrs name (mapAttrs' func attrs);
  list = func: foldl' (x: y: x + y + " ") "" (attrNames func);

  ## Files Map
  files = {
    directory,
    recursive ? false,
    apply ? id,
    extension,
    check ? (_: true),
  }:
    filter checkName (name: type: let
      path = "${toString directory}/${name}";
    in
      if (type == "directory" || type == "symlink") && recursive
      then nameValuePair name (files {inherit path apply;})
      else if
        (type == "directory" || type == "symlink")
        && (
          if (extension == ".nix")
          then pathExists "${path}/default.nix"
          else true
        )
      then nameValuePair name (apply path)
      else if
        type
        == "regular"
        && (
          if (extension == ".nix")
          then name != "default.nix" && name != "flake.nix"
          else true
        )
        && hasSuffix extension name
        && (check path)
      then nameValuePair (removeSuffix extension name) (apply path)
      else nameValuePair "" null) (readDir directory);

  # Module Imports
  modules = {
    __functor = _: directory: apply:
      files {
        inherit directory apply;
        extension = ".nix";
        check = checkAttr;
      };

    list = path: attrValues (modules path id);
    name = path: attrNames (modules path id);
  };

  # Flake Imports
  flake = directory:
    attrValues (filter checkName (name: type: let
      path = "${toString directory}/${name}";
    in
      if
        (type == "directory" || type == "symlink")
        && (pathExists "${path}/flake.nix")
      then nameValuePair name "${path}/flake.nix"
      else nameValuePair "" null) (readDir directory));

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

  # 'sops' Encrypted Secrets
  secrets = directory: neededForUsers:
    filter checkName (name: type:
      if type == "regular" && hasSuffix ".secret" name
      then
        nameValuePair name {
          sopsFile = directory + "/${name}";
          format = "binary";
          inherit neededForUsers;
        }
      else nameValuePair "" null) (readDir directory);
}

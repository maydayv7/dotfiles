## Mapping Functions ##
lib: let
  inherit
    (builtins)
    attrNames
    attrValues
    isPath
    pathExists
    readDir
    readFile
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
    optionalAttrs
    removeSuffix
    replaceStrings
    ;

  # Import Checks
  checkName = name: _: !(hasPrefix "_" name);
  checkAttr = name: let
    type = typeOf (import name);
  in
    type == "set" || type == "lambda";
in rec {
  array = list: func: forEach list (name: getAttrFromPath [name] func);
  filter = name: func: attrs:
    filterAttrs (_: type: type != null) (mapAttrs' func (filterAttrs name attrs));

  ## Files Map
  files = {
    directory,
    recursive ? false,
    apply ? id,
    extension,
    check ? (_: true),
  }:
    filter checkName (
      name: type: let
        path = "${toString directory}/${name}";
      in
        if (type == "directory" || type == "symlink") && recursive
        then
          nameValuePair name (files {
            inherit path apply;
          })
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
        else nameValuePair "" null
    ) (readDir directory);

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

  # Configuration Folder Creation
  folder = {
    directory,
    path,
    extension ? "",
    apply,
    replace ? {
      placeholders = {};
      values = {};
    },
  }:
    mapAttrs' (name: value: nameValuePair "${path}/${name}${extension}" (apply value)) (files {
      inherit directory extension;
      apply = file: with replace; replaceStrings placeholders values (readFile file);
    });

  # Package Patches
  patches = patch:
    if isPath patch
    then
      flatten (
        mapAttrsToList (
          name: type:
            if type == "regular" && (hasSuffix ".diff" name || hasSuffix ".patch" name)
            then patch + "/${name}"
            else null
        ) (readDir patch)
      )
    else patch;

  # 'sops' Encrypted Secrets
  secrets = {
    directory,
    neededForUsers ? false,
  }:
    filter checkName (
      name: type:
        if type == "regular" && hasSuffix ".secret" name
        then
          nameValuePair name ({
              sopsFile = directory + "/${name}";
              format = "binary";
            }
            // optionalAttrs neededForUsers {inherit neededForUsers;})
        else nameValuePair "" null
    ) (readDir directory);
}

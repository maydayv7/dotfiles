{ lib, ... }:
let
  inherit (builtins) attrNames foldl' pathExists readDir toString;
  inherit (lib) filterAttrs hasPrefix hasSuffix mapAttrs' nameValuePair recursiveUpdate removeSuffix;
in rec
{
  ## Mapping Functions ##
  filter = name: func: attrs: filterAttrs name (mapAttrs' func attrs);
  list = func: foldl' (x: y: x + y + "\n  ") "" (attrNames func);
  merge = name: dir1: dir2: func: recursiveUpdate (name dir1 func) (name dir2 func);

  # Module Imports
  modules = dir: func:
    filter
      (name: type: type != null && !(hasPrefix "_" name))
      (name: type:
      let
        path = "${toString dir}/${name}";
      in
        if type == "directory" && pathExists "${path}/default.nix"
          then nameValuePair name (func path)
        else if type == "regular" && name != "default.nix" && hasSuffix ".nix" name
          then nameValuePair (removeSuffix ".nix" name) (func path)
        else nameValuePair "" null)
      (readDir dir);

  modules' = dir: func:
    filter
      (name: type: type != null && !(hasPrefix "_" name))
      (name: type:
      let
        path = "${toString dir}/${name}";
      in
        if type == "directory"
          then nameValuePair name (modules' path func)
        else if type == "regular" && name != "default.nix" && hasSuffix ".nix" name
          then nameValuePair (removeSuffix ".nix" name) (func path)
        else nameValuePair "" null)
      (readDir dir);

  # Sops Encrypted Secrets
  secrets = dir: choice:
    filter
      (name: type: type != null && !(hasPrefix "_" name) && !(hasSuffix "keep" name))
      (name: type:
        (nameValuePair name
        {
          sopsFile =  dir + "/${name}";
          format = "binary";
          neededForUsers = choice;
        }))
      (readDir dir);
}

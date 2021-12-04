{ system, lib, inputs, ... }:
let
  inherit (builtins) attrValues readDir toString hashString pathExists;
  inherit (lib) flatten mapAttrs' mapAttrsToList filterAttrs hasPrefix hasSuffix nameValuePair removeSuffix;
in rec
{
  ## Map Functions ##
  filter = name: func: attrs: filterAttrs name (mapAttrs' func attrs);

  # Module Mapping Function
  modules = dir: func:
    filter
      (name: type: type != null && !(hasPrefix "_" name))
      (name: type:
        let
          path = "${toString dir}/${name}";
        in
        if type == "directory" && pathExists "${path}/default.nix"
          then nameValuePair name (func path)
        else if type == "regular" && name != "default.nix" && name != "repl.nix" && hasSuffix ".nix" name
          then nameValuePair (removeSuffix ".nix" name) (func path)
        else nameValuePair "" null)
      (readDir dir);

  # Package Set Mapping Function
  packages = pkgs: overlays: patches: import (pkgs.legacyPackages."${system}".applyPatches
  {
    name = "patched-input-${hashString "md5" (toString pkgs)}";
    src = pkgs;
    inherit patches;
  })
  {
    inherit system;
    overlays = overlays ++ (attrValues inputs.self.overlays);
    config =
    {
      allowAliases = true;
      allowUnfree = true;
    };
  };

  # Patch Mapping Function
  patches = dir: flatten (mapAttrsToList (name: type:
  if hasSuffix ".diff" name || hasSuffix ".patch" name
    then dir + "/${name}"
  else null)
  (readDir dir));

  # Secrets Mapping Function
  secrets = dir: choice:
    mapAttrs' (name: type: (nameValuePair name
    {
      sopsFile =  dir + "/${name}";
      format = "binary";
      neededForUsers = choice;
    })) (readDir dir);
}

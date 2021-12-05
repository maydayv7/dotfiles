{ system, lib, inputs, ... }:
let
  inherit (builtins) attrValues mapAttrs readDir typeOf toString hashString pathExists;
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
        else if type == "regular" && name != "default.nix" && hasSuffix ".nix" name
          then nameValuePair (removeSuffix ".nix" name) (func path)
        else nameValuePair "" null)
      (readDir dir);

  # Package Set Mapping Function
  packages = pkgs: overlays: patches: import (pkgs.legacyPackages."${system}".applyPatches
  {
    name = "patched-input-${hashString "md5" (toString pkgs)}";
    src = pkgs;
    patches = if typeOf patches == "list" then patches
    else flatten (mapAttrsToList (name: type:
      if hasSuffix ".diff" name || hasSuffix ".patch" name
        then patches + "/${name}"
      else null)
    (readDir patches));
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

  # Nix Input Mapping Functions
  nix =
  {
    registry = mapAttrs (name: value: { flake = value; }) (filterAttrs (name: value: value ? outputs) inputs);
    etc = mapAttrs' (name: value: { name = "nix/inputs/${name}"; value = { source = value.outPath; }; }) inputs;
    path = mapAttrsToList (name: value: "${name}=/etc/nix/inputs/${name}") (filterAttrs (name: value: value.outputs ? legacyPackages || value.outputs ? packages) (filterAttrs (name: value: value ? outputs) inputs));
  };

  # Secrets Mapping Function
  secrets = dir: choice:
    filter
      (name: type: type != null && !(hasPrefix "_" name))
      (name: type:
        (nameValuePair name
        {
          sopsFile =  dir + "/${name}";
          format = "binary";
          neededForUsers = choice;
        }))
      (readDir dir);
}

{ systems, lib, inputs, files }:
let
  inherit (inputs) self;
  inherit (builtins) map hasAttr attrValues mapAttrs listToAttrs readDir typeOf substring toString hashString pathExists;
  inherit (lib) flatten mapAttrs' mapAttrsToList filterAttrs hasPrefix hasSuffix nameValuePair removeSuffix recursiveUpdate;
in rec
{
  ## Mapping Functions ##
  filter = name: func: attrs: filterAttrs name (mapAttrs' func attrs);
  merge = name: dir1: dir2: func: recursiveUpdate (name dir1 func) (name dir2 func);
  eachSystem = func: listToAttrs (map (name: nameValuePair name (func name)) systems);

  # Configuration Checks
  checks =
  {
    system = func: mapAttrs (name: value: value.config.system.build.toplevel) func;
    iso = func: mapAttrs (name: value: "${value}" + ".iso".config.system.build.isoImage) func;
  };

  # Inputs Package Channels
  input = channel: overlays: patches: eachSystem (system: import (channel.legacyPackages."${system}".applyPatches
  {
    name = "patched-input-${hashString "md5" (toString channel)}";
    src = channel;
    patches = if typeOf patches == "list" then patches
    else flatten (mapAttrsToList (name: type:
      if hasSuffix ".diff" name || hasSuffix ".patch" name
        then patches + "/${name}"
      else null)
    (readDir patches));
  })
  {
    inherit system;
    overlays = overlays ++ (attrValues self.overlays);
    config =
    {
      allowAliases = true;
      allowUnfree = true;
    };
  });

  # NixOS Label
  label =
    if self.sourceInfo ? lastModifiedDate && self.sourceInfo ? shortRev
      then "${substring 0 8 self.sourceInfo.lastModifiedDate}.${self.sourceInfo.shortRev}"
    else "dirty";

  # Mime Types
  mime = value:
    listToAttrs (flatten (mapAttrsToList (name: types:
      if hasAttr name value
        then map (type: nameValuePair (type) (value."${name}")) types
      else [ ])
    (import files.xdg.mime)));

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

  # Nix Management
  nix =
  {
    # Flakes Registry
    registry = mapAttrs (name: value: { flake = value; }) (filterAttrs (name: value: value ? outputs) inputs);

    # Nix Path
    inputs = mapAttrs' (name: value: { name = "nix/inputs/${name}"; value = { source = value.outPath; }; }) inputs;
    path = mapAttrsToList (name: value: "${name}=/etc/nix/inputs/${name}") (filterAttrs (name: value: value.outputs ? legacyPackages || value.outputs ? packages) (filterAttrs (name: value: value ? outputs) inputs));
  };

  # Secrets
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

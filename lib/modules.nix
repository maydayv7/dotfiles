{ lib, ... }:
let
  inherit (builtins) attrValues readDir pathExists concatLists;
  inherit (lib) id mapAttrs' mapAttrsToList filterAttrs hasPrefix hasSuffix nameValuePair removeSuffix;
in rec
{
  ## Module Mapping Function ##
  filter = n: v: attrs: filterAttrs n (mapAttrs' v attrs);
  map = dir: fn:
    filter
      (n: v: v != null && !(hasPrefix "_" n))
      (n: v:
        let
          path = "${toString dir}/${n}";
        in
        if v == "directory" && pathExists "${path}/default.nix"
          then nameValuePair n (fn path)
        else if v == "regular" && n != "default.nix" && hasSuffix ".nix" n
          then nameValuePair (removeSuffix ".nix" n) (fn path)
        else nameValuePair "" null)
      (readDir dir);
}

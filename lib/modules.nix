{ lib, ... }:
let
  inherit (builtins) readDir pathExists;
  inherit (lib) mapAttrs' filterAttrs hasPrefix hasSuffix nameValuePair removeSuffix;
in rec
{
  ## Module Mapping Function ##
  filter = n: v: attrs: filterAttrs n (mapAttrs' v attrs);
  map = dir: func:
    filter
      (n: v: v != null && !(hasPrefix "_" n))
      (n: v:
        let
          path = "${toString dir}/${n}";
        in
        if v == "directory" && pathExists "${path}/default.nix"
          then nameValuePair n (func path)
        else if v == "regular" && n != "default.nix" && hasSuffix ".nix" n
          then nameValuePair (removeSuffix ".nix" n) (func path)
        else nameValuePair "" null)
      (readDir dir);
}

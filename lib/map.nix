{ system, lib, inputs, ... }:
let
  inherit (builtins) attrValues readDir pathExists;
  inherit (lib) mapAttrs' filterAttrs hasPrefix hasSuffix nameValuePair removeSuffix;
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
  packages = pkgs: overlay: import pkgs
  {
    inherit system;
    overlays = overlay ++ (attrValues inputs.self.overlays);
    config =
    {
      allowAliases = true;
      allowUnfree = true;
    };
  };

  # Input Patch Mapping Function
  patches = pkgs: local: remote: pkgs.legacyPackages."${system}".applyPatches
  {
    name = "nixpkgs-patched";
    src = pkgs;
    patches = local ++ builtins.map pkgs.legacyPackages."${system}".fetchpatch remote;
  };

  # Secrets Mapping Function
  secrets = dir: choice:
    mapAttrs' (name: type: (nameValuePair name
    {
      sopsFile =  dir + "/${name}";
      format = "binary";
      neededForUsers = choice;
    })) (readDir dir);
}

{ system, lib, inputs, ... }:
let
  inherit (builtins) attrValues;
in rec
{
  ## Package Build Function ##
  build = pkgs: overlays: import pkgs
  {
    inherit system;
    overlays = overlays ++ (attrValues inputs.self.overrides);
    config =
    {
      allowAliases = true;
      allowUnfree = true;
    };
  };
}

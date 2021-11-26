{ system, lib, inputs, ... }:
rec
{
  ## Package Set Build Function ##
  build = pkgs: overlay: import pkgs
  {
    inherit system;
    overlays = overlay ++ (builtins.attrValues inputs.self.overlays);
    config =
    {
      allowAliases = true;
      allowUnfree = true;
    };
  };
}

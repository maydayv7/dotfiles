{ inputs, pkgs, ... }:
with pkgs;
{
  ## Custom Self-Built Packages ##
  custom =
  {
    # Custom Fonts
    fonts = callPackage ./fonts { inherit inputs; };
  };
}

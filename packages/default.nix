{ pkgs, ... }:
with pkgs;
{
  custom =
  {
    # Custom Fonts
    fonts = callPackage ./fonts.nix {};
  };
}

{ inputs, pkgs, ... }:
with pkgs;
{
  ## Custom Self-Built Packages ##
  custom =
  {
    # Custom Fonts
    fonts = callPackage ./fonts.nix { };

    # Firefox GNOME Theme
    gnome-firefox = callPackage ./firefox.nix { inherit inputs; };
  };
}

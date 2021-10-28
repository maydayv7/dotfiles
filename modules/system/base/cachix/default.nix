{ config, lib, pkgs, ... }:
let
  cfg = config.base.enable;
in rec
{
  ## Package Cache Configuration using Cachix ##
  config = lib.mkIf (cfg == true)
  {
    environment.systemPackages = with pkgs; [ cachix ];

    nix =
    {
      binaryCaches =
      [
        "https://cache.nixos.org"
        "https://maydayv7-dotfiles.cachix.org"
      ];
      binaryCachePublicKeys = [ "maydayv7-dotfiles.cachix.org-1:dpECO0Z2ZMttY6JgWHuAR5M7cqeyfFjUsvHdnMz+j6U=" ];
    };
  };
}

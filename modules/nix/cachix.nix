{ pkgs, ... }:
rec
{
  ## Binary Cache using Cachix ##
  config =
  {
    environment.systemPackages = with pkgs; [ cachix ];

    nix =
    {
      binaryCaches =
      [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://maydayv7-dotfiles.cachix.org"
      ];

      binaryCachePublicKeys =
      [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "maydayv7-dotfiles.cachix.org-1:dpECO0Z2ZMttY6JgWHuAR5M7cqeyfFjUsvHdnMz+j6U="
      ];
    };
  };
}

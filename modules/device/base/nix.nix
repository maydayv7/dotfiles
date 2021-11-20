{ config, secrets, lib, inputs, pkgs, ... }:
let
  device = config.device.enable;
  iso = config.iso.enable;
in rec
{
  ## Nix Settings ##
  config = lib.mkIf (device || iso)
  (lib.mkMerge
  [
    {
      # Utilities
      environment.systemPackages = with pkgs; [ cachix ];

      nix =
      {
        # Cachix Binary Cache
        binaryCaches =
        [
          "https://cache.nixos.org"
          "https://maydayv7-dotfiles.cachix.org"
        ];
        binaryCachePublicKeys = [ "maydayv7-dotfiles.cachix.org-1:dpECO0Z2ZMttY6JgWHuAR5M7cqeyfFjUsvHdnMz+j6U=" ];

        # Garbage Collection
        autoOptimiseStore = true;
        gc =
        {
          automatic = true;
          dates     = "weekly";
          options   = "--delete-older-than 7d";
        };

        # Nix Path
        nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

        # User Permissions
        trustedUsers = [ "root" "@wheel" ];

        # Flakes
        package = pkgs.unstable.nix_2_4;
        extraOptions = "experimental-features = nix-command flakes";
        registry =
        {
          self.flake = inputs.self;
          nixpkgs.flake = inputs.nixpkgs;
          unstable.flake = inputs.unstable;
          home-manager.flake = inputs.home;
        };
      };
    }

    (lib.mkIf device
    {
      # Github Authentication Token
      nix.extraOptions = "access-tokens = github.com=${secrets.github}";
    })
  ]);
}

{ inputs, pkgs, ... }:
rec
{
  imports = [ ./cachix.nix ];

  ## Nix Settings ##
  config =
  {
    nix =
    {
      package = pkgs.nix_2_4;

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

      # Additional Features
      extraOptions = "experimental-features = nix-command flakes recursive-nix";
      systemFeatures = [ "kvm" "recursive-nix" ];

      # Flakes
      registry =
      {
        self.flake = inputs.self;
        nixpkgs.flake = inputs.nixpkgs;
        unstable.flake = inputs.unstable;
        home-manager.flake = inputs.home;
      };
    };
  };
}

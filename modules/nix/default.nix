{ inputs, pkgs, ... }:
rec
{
  imports =
  [
    ./cachix.nix
    inputs.utils.nixosModules.autoGenFromInputs
  ];

  ## Nix Settings ##
  config =
  {
    environment.systemPackages = with pkgs; [ manix ];
    nix =
    {
      # Version
      package = pkgs.unstable.nixStable;

      # Garbage Collection
      autoOptimiseStore = true;
      gc =
      {
        automatic = true;
        dates     = "weekly";
        options   = "--delete-older-than 7d";
      };

      # User Permissions
      trustedUsers = [ "root" "@wheel" ];

      # Nix Path
      linkInputs = true;
      generateNixPathFromInputs = true;
      generateRegistryFromInputs = true;

      # Additional Features
      useSandbox = true;
      extraOptions = "experimental-features = nix-command flakes recursive-nix";
      systemFeatures = [ "kvm" "recursive-nix" ];
    };
  };
}

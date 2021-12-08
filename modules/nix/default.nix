{ config, lib, util, pkgs, ... }:
let
  inherit (util) map;
  hardware = config.hardware;
in rec
{
  imports = [ ./cachix.nix ];

  ## Nix Settings ##
  config =
  {
    # Nix Path
    environment.etc = map.nix.inputs;
    nix.nixPath = map.nix.path;
    nix.registry = map.nix.registry;

    nix =
    {
      # Version
      package = pkgs.nix_2_4;

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

      # Additional Features
      maxJobs = if (builtins.hasAttr "cores" hardware) then hardware.cores else 4;
      extraOptions = "experimental-features = nix-command flakes recursive-nix";
      systemFeatures = [ "kvm" "recursive-nix" ];
    };
  };
}

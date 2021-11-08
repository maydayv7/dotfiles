{ config, lib, inputs, pkgs, ... }:
let
  cfg = config.base.enable;
in rec
{
  ## Nix Settings ##
  config = lib.mkIf (cfg == true)
  {
    nix =
    {
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
      extraOptions =
      ''
        experimental-features = nix-command flakes
      '';
      registry =
      {
        self.flake = inputs.self;
        nixpkgs.flake = inputs.nixpkgs;
        unstable.flake = inputs.unstable;
        home-manager.flake = inputs.home-manager;
      };
    };
  };
}

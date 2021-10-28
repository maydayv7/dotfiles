{ config, lib, inputs, pkgs, ... }:
with lib;
with builtins;
let
  cfg = config.base.enable;
in rec
{
  config = mkIf (cfg == true)
  {
    # Nix Settings
    nix =
    {
      autoOptimiseStore = true;
      # Garbage Collection
      gc =
      {
        automatic = true;
        dates     = "weekly";
        options   = "--delete-older-than 7d";
      };
      # Nix Path
      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
      # Flakes
      package = pkgs.nixUnstable;
      extraOptions =
      ''
        experimental-features = nix-command flakes
      '';
      # Flakes Registry
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

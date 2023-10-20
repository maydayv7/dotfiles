{
  lib,
  inputs,
  pkgs,
  ...
}:
with {inherit (lib.util.map) array;}; {
  imports = [./index.nix inputs.utils.nixosModules.autoGenFromInputs];

  ## Nix Settings ##
  config = {
    # Utilities
    user.persist.directories = [".cache/nix" ".cache/manix"];
    environment.systemPackages = [pkgs.cachix] ++ array (import ./format.nix) pkgs;

    # Settings
    nix = {
      # Version
      package = pkgs.nix;

      # Garbage Collection
      settings.auto-optimise-store = true;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };

      # Registry
      linkInputs = true;
      generateNixPathFromInputs = true;
      generateRegistryFromInputs = true;

      # User Permissions
      settings = {
        allowed-users = ["root" "@wheel"];
        trusted-users = ["root" "@wheel"];

        # Additional Features
        sandbox = true;
        system-features = ["kvm" "recursive-nix"];
      };
      extraOptions = ''
        accept-flake-config = true
        warn-dirty = false
        experimental-features = nix-command flakes recursive-nix
        min-free = ${toString (1024 * 1024 * 1024)}
        max-free = ${toString (10 * 1024 * 1024 * 1024)}
      '';
    };
  };
}

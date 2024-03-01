{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption optionals;
  inherit (config.nix) tools;
  flake = (import ../../flake.nix).nixConfig;
in {
  imports = [./index.nix inputs.utils.nixosModules.autoGenFromInputs];

  options.nix.tools = mkEnableOption "Enable Additional Nix Tools";

  ## Nix Settings ##
  config = {
    # Settings
    nix = {
      # Version
      package = pkgs.nixFlakes;

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

      settings = {
        # User Permissions
        allowed-users = ["root" "@wheel"];
        trusted-users = ["root" "@wheel"];

        # Binary Cache
        inherit (flake) trusted-substituters trusted-public-keys;

        # Additional Features
        sandbox = true;
        system-features = optionals tools ["kvm" "big-parallel" "recursive-nix"];
      };

      extraOptions = ''
        accept-flake-config = true
        warn-dirty = false
        experimental-features = nix-command flakes recursive-nix
        min-free = ${toString (1024 * 1024 * 1024)}
        max-free = ${toString (10 * 1024 * 1024 * 1024)}
      '';
    };

    # Utilities
    user.persist.directories = [".cache/nix"] ++ optionals tools [".cache/manix"];
    environment.systemPackages =
      [pkgs.cachix]
      ++ optionals tools (with pkgs; [
        alejandra
        manix
        nodePackages.prettier
        shellcheck
        statix
      ]);
  };
}

{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption optionals util;
  inherit (config.nix) tools;
in {
  imports = [./index.nix inputs.utils.nixosModules.autoGenFromInputs];

  options.nix.tools = mkEnableOption "Enable Additional Nix Tools";

  ## Nix Settings ##
  config = {
    # Utilities
    user.persist.directories = [".cache/nix"] ++ optionals tools [".cache/manix"];
    environment.systemPackages =
      [pkgs.cachix]
      ++ optionals tools (util.map.array (import ./tools.nix) pkgs);

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

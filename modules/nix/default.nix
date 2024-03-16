{pkgs, ...}: {
  imports = [./index.nix ./registry.nix ./tools.nix];

  ## Nix Settings ##
  config = {
    # Settings
    user.persist.directories = [".cache/nix"];
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

      settings = {
        sandbox = true;

        # User Permissions
        allowed-users = ["root" "@wheel"];
        trusted-users = ["root" "@wheel"];

        # Binary Cache
        inherit ((import ../../flake.nix).nixConfig) trusted-substituters trusted-public-keys;
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

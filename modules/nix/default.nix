{ inputs, pkgs, ... }: rec {
  imports = [ inputs.utils.nixosModules.autoGenFromInputs ];

  ## Nix Settings ##
  config = {
    environment.systemPackages = with pkgs; [ cachix nixfmt nix-linter manix ];
    nix = {
      # Version
      package = pkgs.nixFlakes;

      # Garbage Collection
      autoOptimiseStore = true;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };

      # User Permissions
      allowedUsers = [ "root" "@wheel" ];
      trustedUsers = [ "root" "@wheel" ];

      # Nix Path
      linkInputs = true;
      generateNixPathFromInputs = true;
      generateRegistryFromInputs = true;

      # Additional Features
      useSandbox = true;
      systemFeatures = [ "kvm" "recursive-nix" ];
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

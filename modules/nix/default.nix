{ inputs, pkgs, ... }: rec {
  imports = [ ./cachix.nix inputs.utils.nixosModules.autoGenFromInputs ];

  ## Nix Settings ##
  config = {
    environment.systemPackages = with pkgs; [ nixfmt nix-linter manix ];
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
      trustedUsers = [ "root" "@wheel" ];

      # Nix Path
      linkInputs = true;
      generateNixPathFromInputs = true;
      generateRegistryFromInputs = true;

      # Additional Features
      useSandbox = true;
      systemFeatures = [ "kvm" "recursive-nix" ];
      extraOptions = ''
        warn-dirty = false
        experimental-features = nix-command flakes recursive-nix
        min-free = ${toString (1024 * 1024 * 1024)}
        max-free = ${toString (10 * 1024 * 1024 * 1024)}
      '';
    };
  };
}

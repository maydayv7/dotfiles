final: prev: {
  # Fix Nix 'direnv' Version
  nix-direnv = prev.nix-direnv.override { enableFlakes = true; };
}

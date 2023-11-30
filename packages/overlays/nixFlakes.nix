final: prev: {
  # Update Nix to latest version
  nixFlakes = prev.nixFlakes.overrideAttrs (old: rec {
    version = "2.19.1";
    src = prev.fetchFromGitHub {
      owner = "NixOS";
      repo = "nix";
      rev = version;
      hash = "sha256-OzAeQwlAF4l0h2uBWGIPvGBYNL6MpBfrdRKwHTRQXl4=";
    };
    patches = old.patches or [];
  });
}

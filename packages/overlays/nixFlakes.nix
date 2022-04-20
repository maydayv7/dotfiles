final: prev: {
  # Update Nix to Latest Version and Patch using unmerged PRs
  nixFlakes = prev.nixFlakes.overrideAttrs (old: rec {
    version = "2.8+";
    longVersion = builtins.replaceStrings ["+"] [""] version + ".0";

    src = prev.fetchFromGitHub {
      owner = "NixOS";
      repo = "nix";
      rev = longVersion;
      sha256 = "sha256-gWYNlEyleqkPfxtGXeq6ggjzJwcXJVdieJxA1Obly9s=";
    };

    patches = [];
    buildInputs = old.buildInputs ++ [final.nlohmann_json];
  });
}

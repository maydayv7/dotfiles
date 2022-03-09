final: prev: {
  # Update Nix to Latest Version and Patch using unmerged PRs
  nixFlakes = prev.nixFlakes.overrideAttrs (old: rec {
    version = "2.7+";
    longVersion = builtins.replaceStrings ["+"] [""] version + ".0";

    src = prev.fetchFromGitHub {
      owner = "NixOS";
      repo = "nix";
      rev = longVersion;
      sha256 = "sha256-m8tqCS6uHveDon5GSro5yZor9H+sHeh+v/veF1IGw24=";
    };

    buildInputs = old.buildInputs ++ [final.nlohmann_json];
    patches = [
      /*
         (prev.fetchpatch {
         name = "dirty-rev.patch";
         sha256 = "sha256-KVXTpSRIsgvyisJeWMan1fUWgyGpx17mUGZjE+QVPbI=";
         url = "https://patch-diff.githubusercontent.com/raw/NixOS/nix/pull/5385.patch";
       })
       */
    ];
  });
}

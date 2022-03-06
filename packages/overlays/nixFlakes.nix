final: prev: {
  # Update Nix to Latest Version and Patch using unmerged PRs
  nixFlakes = prev.nixFlakes.overrideAttrs (old: {
    version = "2.7+";

    src = prev.fetchFromGitHub {
      owner = "NixOS";
      repo = "nix";
      rev = "391f4fcabe6c307afeb2f39dec07d43f1e6bf748";
      sha256 = "sha256-tZZJiLsT2RHcJWAA8yOstARoff316wrlz3wnsfxFy18=";
    };

    buildInputs = old.buildInputs ++ [final.pkgs.nlohmann_json];
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

final: prev: {
  # Update Nix to Latest Version and Patch using unmerged PRs
  nixFlakes = prev.nixFlakes.overrideAttrs (_: {
    version = "2.6+";

    src = prev.fetchFromGitHub {
      owner = "NixOS";
      repo = "nix";
      rev = "2.6.1";
      sha256 = "sha256-E9iQ7f+9Z6xFcUvvfksTEfn8LsDfzmwrcRBC//5B3V0=";
    };

    patches = [
      (prev.fetchpatch {
        name = "dirty-rev.patch";
        sha256 = "sha256-KVXTpSRIsgvyisJeWMan1fUWgyGpx17mUGZjE+QVPbI=";
        url = "https://patch-diff.githubusercontent.com/raw/NixOS/nix/pull/5385.patch";
      })
    ];
  });
}

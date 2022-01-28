final: prev: {
  # Update Nix to Latest Version and Patch using unmerged PRs
  nixFlakes = prev.nixFlakes.overrideAttrs (_: {
    version = "2.6+";

    src = prev.fetchFromGitHub {
      owner = "NixOS";
      repo = "nix";
      rev = "2.6.0";
      sha256 = "sha256-xEPeMcNJVOeZtoN+d+aRwolpW8mFSEQx76HTRdlhPhg=";
    };

    patches = [ ];
  });
}

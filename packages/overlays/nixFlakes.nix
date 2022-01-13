final: prev: {
  # Patch and Update Nix to latest version with unmerged PRs
  nixFlakes = prev.nixFlakes.overrideAttrs (old: {
    version = "2.5";

    src = prev.fetchFromGitHub {
      owner = "NixOS";
      repo = "nix";
      rev = "2.5.1";
      sha256 = "sha256-GOsiqy9EaTwDn2PLZ4eFj1VkXcBUbqrqHehRE9GuGdU=";
    };

    patches = old.patches ++ [
      # Features
      (prev.fetchpatch {
        name = "dirty-rev.patch";
        sha256 = "sha256-50qV1srrwbCICgY9XRvX7EHpU1ZtdXE8jkCgy5QeMh0=";
        url =
          "https://patch-diff.githubusercontent.com/raw/NixOS/nix/pull/5385.patch";
      })
      (prev.fetchpatch {
        name = "relative-paths.patch";
        sha256 = "sha256-ViKA4INyiTFlauyPPp0tI7sTqtXyk+VXphiAOb8XAxc=";
        url =
          "https://patch-diff.githubusercontent.com/raw/NixOS/nix/pull/5437.patch";
      })

      # Performance
      (prev.fetchpatch {
        name = "parser.patch";
        sha256 = "sha256-x60kV4DKR1W9k5qyK+peSQ1eWNSxhJDuBm6eePbshBI=";
        url =
          "https://patch-diff.githubusercontent.com/raw/NixOS/nix/pull/5812.patch";
      })

      # UI/UX
      (prev.fetchpatch {
        name = "worktree-paths.patch";
        sha256 = "sha256-H8kk6AFbNQA5Zod69ujbRPDZjczzANQYL85G3CUNRVY=";
        url =
          "https://patch-diff.githubusercontent.com/raw/NixOS/nix/pull/5625.patch";
      })
    ];
  });
}

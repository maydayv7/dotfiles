final: prev: {
  # Patch and Update Nix to latest version with unmerged PRs
  nixFlakes = prev.nixFlakes.overrideAttrs (old: {
    version = "2.5+";

    src = prev.fetchFromGitHub {
      owner = "NixOS";
      repo = "nix";
      rev = "2.5.1";
      sha256 = "sha256-GOsiqy9EaTwDn2PLZ4eFj1VkXcBUbqrqHehRE9GuGdU=";
    };

    patches = old.patches ++ [
      (prev.fetchpatch {
        name = "commit-message.patch";
        sha256 = "sha256-ei5TZ8mhI5yNyzIiDZ314uK1BpBaMdDwDRAVZaAP9Aw=";
        url =
          "https://patch-diff.githubusercontent.com/raw/maydayv7/nix/pull/1.patch";
      })
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
      (prev.fetchpatch {
        name = "worktree-paths.patch";
        sha256 = "sha256-H8kk6AFbNQA5Zod69ujbRPDZjczzANQYL85G3CUNRVY=";
        url =
          "https://patch-diff.githubusercontent.com/raw/NixOS/nix/pull/5625.patch";
      })
    ];
  });
}

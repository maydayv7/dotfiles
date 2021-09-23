# dconf2nix
# https://github.com/gvolpe/dconf2nix
(self: super:
  {
    dconf2nix = super.dconf2nix.overrideAttrs (old: rec 
    {
      src = super.fetchFromGitHub
      {
        owner = "gvolpe";
        repo = "dconf2nix";
        rev = "d96e3697aae2b24c7bd12eb6ec68a6b24a8b1b2c";
        sha256 = "1293gc90i848n25iwsbf1fzd11aakvcsv095y27mfbsyhs1lg67p";
      };
    });
  }
)

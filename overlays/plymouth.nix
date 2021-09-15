# Overlay for latest Plymouth
self: super:
{
  plymouth = super.plymouth.overrideAttrs (old: {
    src = super.fetchFromGitHub
      {
        owner = "maydayv7";
        repo = "plymouth-nixos";
        rev = "42aa1344774830ac49b56481cf18cf28fbef32a5";
        sha256 = "1hgpvzgkprh1g2gim3mqnzmgj64khr3fzqcflr0mqrhy79xmbb3v";
      };
  });
}

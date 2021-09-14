# Overlay for latest Plymouth
self: super:
{
  plymouth = super.plymouth.overrideAttrs (old: {
    src = super.fetchFromGitHub
      {
        owner = "maydayv7";
        repo = "plymouth-nixos";
        rev = "cd46a74f69f08f2cc7847c441e6688f64afec024";
        sha256 = "0ahqfdsjjvn95063krg7bac3nm8krghmgwahgrh8j278ybyiixps";
      };
  });
}

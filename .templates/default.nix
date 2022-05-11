lib:
with {inherit (lib.filters) filter matchExt;}; {
  ## Configuration Templates ##
  default = {
    description = "Simple, Minimal NixOS Configuration";
    path = filter {
      root = ./minimal;
      include = [(matchExt "nix")];
    };
  };

  extensive = {
    description = "My Complete, Extensive NixOS Configuration";
    path = filter {
      root = ../.;
      exclude = [
        ./.github
        ./.gitlab
        ./site
        ./packages/website.nix
        (matchExt "md")
        (matchExt "secret")
      ];
    };
  };
}

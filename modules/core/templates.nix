## Flake Template ##
{inputs, ...}: {
  flake.templates.default = with inputs.filters.lib; {
    description = "My NixOS Configuration";
    path = filter {
      root = ../../.;
      exclude = [
        ../../site
        (matchExt "md")
        (matchExt "gpg")
        (matchExt "secret")
      ];
    };
  };
}

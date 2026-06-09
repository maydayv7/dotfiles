# Flake template
{inputs, ...}: {
  flake.templates.default = with inputs.filters.lib; {
    description = "My NixOS Configuration";
    path = filter {
      root = ../../.;
      exclude = [
        ../../checks
        ../../site
        (matchExt "md")
        (matchExt "secret")
      ];
    };
  };
}

lib: let
  inherit (builtins) attrNames;
  inherit (lib) genAttrs id mapAttrs';
in {
  ## Packager Functions ##
  # Device Configurations
  device = attrs:
    mapAttrs' (_: name: {
      name = "Device-${name}";
      value = attrs."${name}".config.system.build."nixos-rebuild";
    }) (genAttrs (attrNames attrs) id);

  # User Home Configurations
  user = attrs: user:
    mapAttrs' (_: name: {
      name = "User-${name}";
      value = attrs."${user}".activationPackage;
    }) (genAttrs (attrNames attrs) id);
}

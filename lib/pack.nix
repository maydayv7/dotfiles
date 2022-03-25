{
  self,
  lib,
  ...
}: let
  inherit (builtins) attrNames;
  inherit (lib) genAttrs id mapAttrs';
in rec {
  ## Packager Functions ##
  # Device Configurations
  device = attrs: check:
    mapAttrs' (_: name: {
      name = "Device-${name}";
      value = attrs."${name}".config.system.build."${check}";
    }) (genAttrs (attrNames attrs) id);

  # User Home Configurations
  user = user:
    mapAttrs' (_: name: {
      name = "User-${name}";
      value = self.homeConfigurations."${user}".activationPackage;
    }) (genAttrs (attrNames self.homeConfigurations) id);
}

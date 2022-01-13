{ lib, inputs, ... }:
let
  inherit (inputs) self;
  inherit (builtins) attrNames;
  inherit (lib) genAttrs mapAttrs';
in rec
{
  ## Packager Functions ##
  # Install Media Configurations
  installMedia = mapAttrs' (_: name: { name = "installMedia-${name}"; value = self.installMedia."${name}".config.system.build.isoImage; }) (genAttrs (attrNames self.installMedia) (name: "${name}"));

  # Device Configurations
  nixosConfigurations = mapAttrs' (_: name: { name = "nixosConfigurations-${name}"; value = self.nixosConfigurations."${name}".config.system.build.toplevel; }) (genAttrs (attrNames self.nixosConfigurations) (name: "${name}"));
}

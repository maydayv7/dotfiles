{ lib, inputs, ... }:
let
  inherit (inputs) self;
  inherit (lib) genAttrs mapAttrs';
  attrNames = attrs: genAttrs (builtins.attrNames attrs) (name: "${name}");
in rec {
  ## Packager Functions ##
  # Install Media Configurations
  installMedia = {
    system = mapAttrs' (_: name: {
      name = "installMedia-${name}";
      value = self.installMedia."${name}".config.system.build.toplevel;
    }) (attrNames self.installMedia);
    iso = mapAttrs' (_: name: {
      name = "installMedia-${name}.iso";
      value = self.installMedia."${name}".config.system.build.isoImage;
    }) (attrNames self.installMedia);
  };

  # Device Configurations
  nixosConfigurations = mapAttrs' (_: name: {
    name = "nixosConfigurations-${name}";
    value = self.nixosConfigurations."${name}".config.system.build.toplevel;
  }) (attrNames self.nixosConfigurations);
}

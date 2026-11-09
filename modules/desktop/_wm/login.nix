## Login Greeter
{inputs ? null, ...}: {
  nixos = {config, ...}: {
    imports = [inputs.noctalia-greeter.nixosModules.default];
    environment.persist.directories = ["/var/lib/noctalia-greeter"];
    services.displayManager.noctalia-greeter = {
      enable = true;
      settings.cursor = {
        path = config.stylix.cursor.package;
        theme = config.stylix.cursor.name;
        inherit (config.stylix.cursor) size;
      };
    };
  };
}

## Docker Containers ##
_: {
  flake.modules.nixos.docker = {pkgs, ...}: {
    virtualisation.docker.enable = true;
    environment = {
      persist.directories = ["/var/lib/docker"];
      systemPackages = [pkgs.docker-compose];
    };
  };
}

## Docker Containers ##
_: {
  flake.modules.nixos.docker = {pkgs, ...}: {
    virtualisation.docker.enable = true;
    environment = {
      persist.directories = ["/var/lib/docker"];
      systemPackages = [pkgs.docker-compose];
    };

    # ? # Use '--add-host=host.docker.internal:host-gateway' to create containers
    networking = {
      firewall.trustedInterfaces = ["docker0"];
      extraHosts = "127.0.0.1 host.docker.internal";
    };
  };
}

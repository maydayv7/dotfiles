# Hyperledger Fabric, Docker support
## Blockchain Support ##
_: {
  flake.modules.nixos.blockchain = {pkgs, ...}: {
    virtualisation.docker.enable = true;
    environment = {
      persist.directories = ["/var/lib/docker"];
      systemPackages = with pkgs; [
        custom.fabric-ca
        hyperledger-fabric

        docker-compose
        nodejs
      ];
    };
  };
}

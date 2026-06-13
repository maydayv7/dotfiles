## Blockchain Support ##
_: {
  flake.modules.nixos.blockchain = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      custom.fabric-ca
      hyperledger-fabric
    ];
  };
}

{
  self,
  lib,
}:
with {inherit (builtins) mapAttrs;}; {
  autoRollback = true;
  magicRollback = false;
  user = "root";
  sshUser = "recovery";
  nodes = mapAttrs (hostname: config: {
    inherit hostname;
    profiles.system.path = lib.deploy."${config.pkgs.system}".activate.nixos
    self.nixosConfigurations."${hostname}";
  })
  self.nixosConfigurations;
}

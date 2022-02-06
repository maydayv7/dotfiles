{ lib, inputs, pkgs, files, ... }:
with { inherit (lib) mkForce util; }; {
  imports = [ inputs.sops.nixosModules.sops ];

  ## Authentication Credentials Management ##
  config = {
    environment.systemPackages = [ pkgs.sops ];
    sops = {
      # Encrypted Secrets
      secrets = util.map.secrets ./. false;

      # GPG Key Import
      gnupg = {
        home = files.gpg;
        sshKeyPaths = mkForce [ ];
      };
    };
  };
}

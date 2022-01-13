{ lib, inputs, pkgs, files, ... }: {
  imports = [ inputs.sops.nixosModules.sops ];

  ## Authentication Credentials Management ##
  config = {
    environment.systemPackages = [ pkgs.sops ];
    sops = {
      # Encrypted Secrets
      secrets = lib.util.map.secrets ./. false;

      # GPG Key Import
      gnupg = {
        home = "${files.gpg}";
        sshKeyPaths = [ ];
      };
    };
  };
}

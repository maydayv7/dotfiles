{
  lib,
  util,
  inputs,
  pkgs,
  files,
  ...
}: {
  imports = [inputs.sops.nixosModules.sops];

  ## Authentication Credentials Management ##
  config = {
    environment = {
      persist.directories = [files.gpg];
      systemPackages = [pkgs.sops];
    };

    sops = {
      # Encrypted Secrets
      secrets = util.map.secrets ./. false;

      # GPG Key Import
      gnupg = {
        home = files.gpg;
        sshKeyPaths = lib.mkForce [];
      };
    };
  };
}

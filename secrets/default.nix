{
  lib,
  inputs,
  pkgs,
  files,
  ...
}: let
  inherit (lib) mkForce util;
in {
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
        sshKeyPaths = mkForce [];
      };
    };
  };
}

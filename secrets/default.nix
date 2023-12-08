{
  config,
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
      secrets = let
        directory = ./. + "/${config.networking.hostName}";
      in
        util.map.secrets {directory = ./.;}
        // (
          if (builtins.pathExists directory)
          then util.map.secrets {inherit directory;}
          else {}
        );

      # GPG Key Import
      gnupg = {
        home = files.gpg;
        sshKeyPaths = lib.mkForce [];
      };
    };
  };
}

{
  config,
  util,
  inputs,
  pkgs,
  files,
  ...
}: let
  path = files.path.gpg;
in {
  imports = [inputs.sops.nixosModules.sops];

  ## Authentication Credentials Management ##
  config = {
    environment = {
      persist.directories = [path];
      systemPackages = [pkgs.sops];
    };

    sops = {
      # GPG Key Import
      gnupg.home = path;

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
    };
  };
}

{ config, lib, inputs, pkgs, files, ... }:
let
  inherit (lib) map;
  path = if (builtins.hasAttr "/persist" config.fileSystems) then "/persist${files.gpg}" else "${files.gpg}";
in
{
  imports = [ inputs.sops.nixosModules.sops ];

  ## Authentication Credentials Management ##
  config =
  {
    environment.systemPackages = with pkgs; [ sops ];
    sops =
    {
      # Encrypted Secrets
      secrets = map.secrets ./. false;

      # GPG Key Import
      gnupg =
      {
        home = "${path}";
        sshKeyPaths = [ ];
      };
    };
  };
}

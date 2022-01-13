{ config, lib, pkgs, files, ... }:
let
  inherit (lib) map;
  path = if (builtins.hasAttr "/persist" config.fileSystems) then
    "/persist${files.gpg}"
  else
    "${files.gpg}";
in {
  ## Authentication Credentials Management ##
  config = {
    environment.systemPackages = [ pkgs.sops ];
    sops = {
      # Encrypted Secrets
      secrets = map.secrets ./. false;

      # GPG Key Import
      gnupg = {
        home = "${path}";
        sshKeyPaths = [ ];
      };
    };
  };
}

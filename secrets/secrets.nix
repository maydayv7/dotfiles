{ config, lib, util, inputs, pkgs, path, ... }:
let
  inherit (util) map;
  persist = if (builtins.hasAttr "/persist" config.fileSystems) then "/persist" else "";
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
      secrets = map.secrets ./encrypted false;

      # GPG Key Import
      gnupg =
      {
        home = "${persist}${path.keys}";
        sshKeyPaths = [ ];
      };
    };
  };
}

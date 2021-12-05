{ config, lib, util, inputs, pkgs, ... }:
let
  inherit (util) map;
  keys = config.users.groups.keys.name;
  path = config.path.keys;
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
        home = "${persist}${path}";
        sshKeyPaths = [ ];
      };
    };
  };
}

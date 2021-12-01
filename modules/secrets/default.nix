{ config, lib, username, inputs, pkgs, ... }:
let
  inherit (builtins) readDir;
  inherit (lib) mkMerge mapAttrs' nameValuePair removeSuffix;
  group = config.users.groups.keys.name;
  path = if (config.fileSystems."/".fsType == "tmpfs") then "/persist" else "";
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
      secrets = mkMerge
      [
        (mapAttrs' (name: type: (nameValuePair name
        {
          sopsFile =  ./encrypted + "/${name}";
          format = "binary";
        })) (readDir ./encrypted))

        {
          "password.root".neededForUsers = true;
          "password.${username}".neededForUsers = true;
        }
      ];

      # GPG Key Import
      gnupg =
      {
        home = "${path}/etc/gpg";
        sshKeyPaths = [ ];
      };
    };

    # User Passwords
    users =
    {
      extraUsers.root.passwordFile = config.sops.secrets."password.root".path;
      users."${username}" =
      {
        passwordFile = config.sops.secrets."password.${username}".path;
        extraGroups = [ group ];
      };
    };
  };
}

{
  config,
  lib,
  util,
  files,
  ...
}: let
  inherit (lib) filterAttrs mkAfter mkForce mkIf;
  inherit (builtins) all attrNames attrValues hasAttr mapAttrs readFile;
  inherit (config.sops) secrets;
  inherit (config.user) settings;
  enable = all (value: value.minimal) (attrValues settings);
in {
  ## Security Settings ##
  config = {
    # Passwords
    services.openssh.enable = mkIf enable (mkForce false);
    sops.secrets =
      if enable
      then (mkForce {})
      else
        util.map.secrets {
          directory = ./passwords;
          neededForUsers = true;
        };

    users = {
      users =
        mapAttrs (name: value: {
          hashedPasswordFile = mkIf (!value.minimal) secrets."${name}.secret".path;
        })
        settings;
      extraUsers.root.hashedPasswordFile =
        mkIf (hasAttr "root.secret" secrets) secrets."root.secret".path;
    };

    # Authentication
    security.sudo = {
      execWheelOnly = true;
      extraConfig = ''
        Defaults pwfeedback
        Defaults lecture = always, lecture_file = ${files.ascii.groot}
      '';

      # Passwordless Access
      extraRules = [
        {
          users = attrNames (filterAttrs (_: value: value.minimal) settings);
          commands = [
            {
              command = "ALL";
              options = ["NOPASSWD" "SETENV"];
            }
          ];
        }
      ];
    };

    # Recovery Account
    specialisation.recovery.configuration =
      mkIf (!(all (value: value.minimal) (attrValues settings)))
      {
        security.sudo.extraConfig = mkAfter "recovery ALL=(ALL:ALL) NOPASSWD:ALL";
        users.extraUsers.recovery = {
          name = "recovery";
          description = "Recovery Account";
          isNormalUser = true;
          uid = 1100;
          group = "users";
          extraGroups = ["wheel"];
          useDefaultShell = true;
          initialHashedPassword = readFile ./passwords/default;
        };
      };
  };
}

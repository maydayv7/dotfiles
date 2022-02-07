{ config, lib, ... }:
let
  inherit (lib) filterAttrs mkIf optional util;
  inherit (builtins) any attrNames attrValues hasAttr mapAttrs readFile;
  inherit (config.sops) secrets;
  inherit (config.user) settings;
  recovery = any (value: value.recovery) (attrValues settings);
in {
  ## Security Settings ##
  config = {
    # Passwords
    sops.secrets = util.map.secrets ./passwords true;
    users.extraUsers.root.passwordFile =
      mkIf (hasAttr "root.secret" secrets) secrets."root.secret".path;
    users.users = mapAttrs (name: value: {
      passwordFile = mkIf (!value.minimal) secrets."${name}.secret".path;
    }) settings;

    # Recovery Account
    users.extraUsers.recovery = mkIf recovery {
      name = "recovery";
      description = "Recovery Account";
      isNormalUser = true;
      uid = 1100;
      group = "users";
      extraGroups = [ "wheel" ];
      useDefaultShell = true;
      initialHashedPassword = readFile ./passwords/default;
    };

    # Authentication
    security.sudo = {
      execWheelOnly = true;
      extraConfig = ''
        Defaults pwfeedback
        Defaults lecture = never
      '';

      # Passwordless Access
      extraRules = [{
        users = attrNames (filterAttrs (_: name: name.minimal) settings)
          ++ optional recovery "recovery";
        commands = [{
          command = "ALL";
          options = [ "NOPASSWD" "SETENV" ];
        }];
      }];
    };
  };
}

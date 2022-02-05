{ config, lib, ... }:
let
  inherit (lib) filterAttrs mkIf optional util;
  inherit (builtins) attrNames hasAttr mapAttrs;
  inherit (config.sops) secrets;
in {
  config = {
    # Passwords
    sops.secrets = util.map.secrets ./passwords true;
    users.extraUsers.root.passwordFile =
      mkIf (hasAttr "root.secret" secrets) secrets."root.secret".path;
    users.users = mapAttrs (name: value: {
      passwordFile = mkIf (!value.minimal) secrets."${name}.secret".path;
    }) config.user.settings;

    # Security Settings
    security.sudo = {
      execWheelOnly = true;
      extraConfig = ''
        Defaults pwfeedback
        Defaults lecture = never
      '';

      # Passwordless 'sudo'
      extraRules = [{
        users =
          attrNames (filterAttrs (_: name: name.minimal) config.user.settings)
          ++ optional config.user.recovery "recovery";
        commands = [{
          command = "ALL";
          options = [ "NOPASSWD" "SETENV" ];
        }];
      }];
    };
  };
}

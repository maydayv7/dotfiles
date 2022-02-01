{ config, lib, ... }:
let
  inherit (lib) filterAttrs mkIf util;
  inherit (builtins) attrNames mapAttrs;
  inherit (config) sops user;
in rec {
  config = {
    # Passwords
    sops.secrets = util.map.secrets ./passwords true;
    users.users = mapAttrs (name: value: {
      passwordFile = mkIf (!value.minimal) sops.secrets."${name}.secret".path;
    }) user.settings;

    # Security Settings
    security.sudo = {
      execWheelOnly = true;
      extraConfig = ''
        Defaults pwfeedback
        Defaults lecture = never
      '';

      # Passwordless 'sudo'
      extraRules = [{
        users = attrNames (filterAttrs (_: name: name.minimal) user.settings)
          ++ (if user.recovery then [ "recovery" ] else [ ]);
        commands = [{
          command = "ALL";
          options = [ "NOPASSWD" "SETENV" ];
        }];
      }];
    };
  };
}

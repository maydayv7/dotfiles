{ config, lib, ... }:
let
  inherit (lib) mkIf util;
  inherit (builtins) mapAttrs;
  inherit (config.sops) secrets;
  users = config.user.settings;
in rec {
  config = {
    # Passwords
    sops.secrets = util.map.secrets ./passwords true;
    users.extraUsers.root.passwordFile = secrets."root.secret".path;
    users.users = mapAttrs (name: _: {
      passwordFile =
        mkIf (!users."${name}".minimal) secrets."${name}.secret".path;
    }) users;

    # Security Settings
    security.sudo = {
      execWheelOnly = true;
      extraConfig = ''
        Defaults pwfeedback
        Defaults lecture = never
      '';
    };
  };
}

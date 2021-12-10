{ config, lib, util, ... }:
let
  inherit (util) map;
  enable = !config.user.autologin;
  secrets = config.sops.secrets;
  username = config.user.name;
in rec
{
  config = lib.mkIf enable
  {
    # Passwords
    sops.secrets = map.secrets ./passwords true;
    users.extraUsers.root.passwordFile = secrets."root".path;
    user.settings.passwordFile = secrets."${username}".path;

    # Security Settings
    security.sudo.extraConfig =
    ''
      Defaults pwfeedback
      Defaults lecture = never
    '';
  };
}

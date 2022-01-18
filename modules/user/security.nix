{ config, lib, ... }:
let
  inherit (lib) mkIf util;
  enable = config.user.password == "";
  inherit (config.sops) secrets;
  username = config.user.name;
in rec {
  config = mkIf enable {
    # Passwords
    sops.secrets = util.map.secrets ./passwords true;
    user.settings.passwordFile = secrets."${username}.secret".path;
    users.extraUsers.root.passwordFile = secrets."root.secret".path;

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

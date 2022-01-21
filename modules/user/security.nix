{ config, lib, ... }:
let
  inherit (lib.util) map;
  inherit (config.sops) secrets;
in rec {
  config = {
    # Passwords
    sops.secrets = map.secrets ./passwords true;
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

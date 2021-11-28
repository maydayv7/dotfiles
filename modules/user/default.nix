{ config, username, ... }:
let
  secrets = config.age.secrets;
in rec
{
  imports = [ ./home.nix ];

  ## User Configuration ##
  config =
  {
    users =
    {
      mutableUsers = false;

      # Passwords
      extraUsers.root.passwordFile = secrets."passwords/root".path;
      users."${username}".passwordFile = secrets."passwords/${username}".path;
    };

    # Security Settings
    security.sudo.extraConfig =
    ''
      Defaults pwfeedback
      Defaults lecture = never
    '';
  };
}

{ config, lib, username, files, ... }:
let
  secrets = config.age.secrets;
in rec
{
  ## Device User Configuration ##
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

    home-manager.users."${username}" =
    {
      # XDG Configuration
      xdg =
      {
        enable = true;
        userDirs =
        {
          enable = true;
          createDirectories = true;
          desktop = "$HOME/Desktop";
          documents = "$HOME/Documents";
          download = "$HOME/Downloads";
          music = "$HOME/Music";
          pictures = "$HOME/Pictures";
          publicShare = "$HOME/Public";
          templates = "$HOME/Templates";
          videos = "$HOME/Videos";
          extraConfig = { XDG_SCREENSHOTS_DIR = "$HOME/Pictures/Screenshots"; };
        };
        mime.enable = true;
      };

      # Wallpapers
      home.file.".local/share/backgrounds".source = files.wallpapers;
    };
  };
}

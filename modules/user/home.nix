{ config, username, files, ... }:
let
  version = config.system.stateVersion;
  homeDir = config.home-manager.users."${username}".home.homeDirectory;
in rec
{
  ## Home Manager Settings ##
  config =
  {
    home-manager =
    {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "bak";
      users."${username}" =
      {
        programs.home-manager.enable = true;
        systemd.user.startServices = true;
        home =
        {
          username = username;
          homeDirectory = "/home/${username}";
          stateVersion = version;
        };

        # XDG Configuration
        xdg =
        {
          enable = true;
          mime.enable = true;
          mimeApps.enable = true;

          # Default Home Folders
          cacheHome = "${homeDir}/.cache";
          configHome = "${homeDir}/.config";
          dataHome = "${homeDir}/.local/share";
          stateHome = "${homeDir}/.local/state";

          # User Home Folders
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
        };

        # Wallpapers
        home.file.".local/share/backgrounds".source = files.wallpapers;
      };
    };
  };
}

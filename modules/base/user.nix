{ config, files, username, lib, inputs, ... }:
let
  pc = (config.device == "PC");
  iso = (config.device == "ISO");
  secrets = config.age.secrets;
in rec
{
  ## Device User Configuration ##
  config = lib.mkIf (pc || iso)
  (lib.mkMerge
  [
    {
      users.mutableUsers = false;

      # Security Settings
      security.sudo.extraConfig =
      ''
        Defaults pwfeedback
        Defaults lecture = never
      '';
    }

    (lib.mkIf pc
    {
      # Passwords
      users =
      {
        extraUsers.root.passwordFile = secrets."passwords/root".path;
        users."${username}".passwordFile = secrets."passwords/${username}".path;
      };

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
    })

    (lib.mkIf iso
    {
      # User Login
      services.xserver.displayManager.autoLogin =
      {
        enable = true;
        user = "${username}";
      };

      # Default User
      users.users.nixos =
      {
        name = "${username}";
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" ];
        uid = 1000;
        initialPassword = "password";
        useDefaultShell = true;
      };

      # Security Settings
      security.sudo.extraConfig = "nixos ALL=(ALL) NOPASSWD:ALL";
    })
  ]);
}

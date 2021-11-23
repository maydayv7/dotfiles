{ config, files, secrets, username, lib, inputs, ... }:
let
  pc = (config.device == "PC");
  iso = (config.device == "ISO");
in rec
{
  ## Device User Configuration ##
  config = lib.mkIf (pc || iso)
  (lib.mkMerge
  [
    {
      users.mutableUsers = false;

      # Root User
      users.extraUsers.root.initialHashedPassword = secrets.root;

      # Security Settings
      security.sudo.extraConfig =
      ''
        Defaults pwfeedback
        Defaults lecture = never
      '';
    }

    (lib.mkIf pc
    {
      # Password
      users.users."${username}".initialHashedPassword = secrets."${username}";

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
        user = "nixos";
      };

      # Default User
      users.users.nixos =
      {
        name = "nixos";
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

{ config, files, username, lib, pkgs, ... }:
let
  enable = config.apps.office.enable;
in rec
{
  options.apps.office.enable = lib.mkEnableOption "Enable Office Environment";

  ## Office Environment Configuration ##
  config = lib.mkIf enable
  {
    # Applications
    environment.systemPackages = with pkgs;
    [
      # Productivity
      bluej
      gscan2pdf
      libreoffice
      unstable.onlyoffice-bin

      # Internet
      google-chrome
      megasync
      teams
      whatsapp-for-linux
      zoom-us

      # Entertainment
      celluloid
      handbrake
      lollypop
    ];

    home-manager.users."${username}".home.file =
    {
      # Document Templates
      "Templates" =
      {
        source = files.templates;
        recursive = true;
      };

      # Font Rendering
      ".local/share/fonts" =
      {
        source = files.fonts.path;
        recursive = true;
      };
    };
  };
}

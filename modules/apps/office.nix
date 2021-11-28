{ config, lib, username, pkgs, files, ... }:
let
  enable = (builtins.elem "office" config.apps.list);
in rec
{
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
      onlyoffice-bin

      # Internet
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

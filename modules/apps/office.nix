{ config, lib, pkgs, files, ... }:
let enable = builtins.elem "office" config.apps.list;
in {
  ## Office Environment Configuration ##
  config = lib.mkIf enable {
    # Applications
    environment.systemPackages = with pkgs; [
      # Productivity
      bluej
      gscan2pdf
      handbrake
      libpst
      libreoffice
      onlyoffice-bin

      # Internet
      google-chrome
      megasync
      teams
      thunderbird
      whatsapp-for-linux
      zoom-us
    ];

    user = {
      # Persisted Files
      persist.files = [ ".config/gscan2pdfrc" ".config/zoomus.conf" ];
      persist.dirs = [
        ".bluej"
        ".thunderbird"
        ".zoom"
        ".config/google-chrome"
        ".config/libreoffice"
        ".config/Microsoft"
        ".config/onlyoffice"
        ".local/share/data"
        ".local/share/onlyoffice"
        ".cache/thunderbird"
        ".cache/google-chrome"
        ".cache/zoom"
      ];

      home.home.file = {
        # Document Templates
        "Templates" = {
          source = files.templates;
          recursive = true;
        };

        # Font Rendering
        ".local/share/fonts" = {
          source = files.fonts.path;
          recursive = true;
        };
      };
    };
  };
}

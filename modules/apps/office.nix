{
  config,
  lib,
  inputs,
  pkgs,
  files,
  ...
}: let
  enable = builtins.elem "office" config.apps.list;
in {
  ## Office Environment Configuration ##
  imports = [inputs.windows.nixosModules.onlyoffice];
  config = lib.mkIf enable {
    # Applications
    programs.onlyoffice = {
      enable = true;
      package = pkgs.onlyoffice-bin_latest;
    };

    environment.systemPackages = with pkgs; [
      # Productivity
      calibre
      gnome.simple-scan
      gscan2pdf
      libreoffice
      obs-studio

      # Graphics
      gimp
      handbrake
      inkscape
      pitivi
      xournalpp

      # Internet
      google-chrome
      linux-wifi-hotspot
      openfortivpn
      thunderbird
      whatsapp-for-linux
      zoom-us

      # Sound
      pwvucontrol
      qpwgraph

      # Utilities
      hunspell
      hunspellDicts.en_US-large
      hyphen
      ventoy-full
    ];

    # Dictionaries
    environment = {
      pathsToLink = ["/share/hunspell" "/share/myspell" "/share/hyphen"];
      variables."DICPATH" = "/run/current-system/sw/share/hunspell:/run/current-system/sw/share/hyphen";
    };

    user = {
      # Persisted Files
      persist.files = [
        ".config/gscan2pdfrc"
        ".config/rncbc.org/qpwgraph"
        ".config/zoomus.conf"
      ];

      persist.directories = [
        ".calibre"
        ".thunderbird"
        ".zoom"
        ".config/calibre"
        ".config/GIMP"
        ".config/google-chrome"
        ".config/inkscape"
        ".config/libreoffice"
        ".config/obs-studio"
        ".config/onlyoffice"
        ".config/pitivi"
        ".config/whatsapp-for-linux"
        ".local/share/data"
        ".local/share/onlyoffice"
        ".local/share/whatsapp-for-linux"
        ".cache/thunderbird"
        ".cache/google-chrome"
        ".cache/whatsapp-for-linux"
        ".cache/zoom"
      ];

      homeConfig = {
        # Utilities
        services.easyeffects.enable = true;

        home.file = {
          # Document Templates
          "Templates" = {
            source = files.templates;
            recursive = true;
          };

          # Font Rendering
          ".local/share/fonts" = {
            source = "${pkgs.custom.fonts}/share/fonts";
            recursive = true;
          };
        };
      };
    };
  };
}

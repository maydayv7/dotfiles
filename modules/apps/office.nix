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
    environment.systemPackages = with pkgs; [
      # Productivity
      gimp
      gnome.simple-scan
      gscan2pdf
      handbrake
      hunspell
      hunspellDicts.en_US-large
      hyphen
      libreoffice
      obs-studio

      # Internet
      google-chrome
      linux-wifi-hotspot
      thunderbird
      whatsapp-for-linux
      zoom-us
    ];

    programs.onlyoffice = {
      enable = true;
      package = pkgs.onlyoffice-bin_latest;
    };

    # Dictionaries
    environment = {
      pathsToLink = ["/share/hunspell" "/share/myspell" "/share/hyphen"];
      variables."DICPATH" = "/run/current-system/sw/share/hunspell:/run/current-system/sw/share/hyphen";
    };

    user = {
      # Persisted Files
      persist.files = [".config/gscan2pdfrc" ".config/zoomus.conf"];
      persist.directories = [
        ".thunderbird"
        ".zoom"
        ".config/GIMP"
        ".config/google-chrome"
        ".config/libreoffice"
        ".config/obs-studio"
        ".config/onlyoffice"
        ".local/share/data"
        ".local/share/onlyoffice"
        ".local/share/whatsapp-for-linux"
        ".cache/thunderbird"
        ".cache/google-chrome"
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

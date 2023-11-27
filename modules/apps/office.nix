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
  imports = [inputs.wine.nixosModules.onlyoffice];

  config = lib.mkIf enable {
    # Applications
    programs.onlyoffice.enable = true;
    environment.systemPackages = with pkgs; [
      # Productivity
      easyeffects
      gscan2pdf
      handbrake
      hunspell
      hunspellDicts.en_US-large
      hyphen
      libreoffice

      # Internet
      google-chrome
      thunderbird
      whatsapp-for-linux
      zoom-us
    ];

    # Dictionaries
    environment = {
      pathsToLink = ["/share/hunspell" "/share/myspell" "/share/hyphen"];
      variables.DICPATH = "/run/current-system/sw/share/hunspell:/run/current-system/sw/share/hyphen";
    };

    user = {
      # Persisted Files
      persist.files = [".config/gscan2pdfrc" ".config/zoomus.conf"];
      persist.directories = [
        ".thunderbird"
        ".zoom"
        ".config/google-chrome"
        ".config/libreoffice"
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
          source = "${pkgs.custom.fonts}/share/fonts";
          recursive = true;
        };
      };
    };
  };
}

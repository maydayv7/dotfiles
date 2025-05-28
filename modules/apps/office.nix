{
  config,
  lib,
  util,
  inputs,
  pkgs,
  files,
  ...
}:
let
  enable = builtins.elem "office" config.apps.list;
in
{
  ## Office Environment Configuration ##
  imports = [ inputs.windows.nixosModules.onlyoffice ];
  config = lib.mkIf enable {
    # Applications
    programs = {
      onlyoffice = {
        enable = true;
        package = pkgs.onlyoffice-bin_latest;
      };

      obs-studio = {
        enable = true;
        enableVirtualCamera = true;
        plugins = with pkgs.obs-studio-plugins; [
          obs-mute-filter
          obs-source-switcher
        ];
      };

      chromium = {
        enable = true;
        extensions = [
          "cjpalhdlnbpafiamejdnhcphjbkeiagm" # UBlock Origin
          "djflhoibgkdhkhhcedjiklpkjnoahfmg" # User Agent Switcher
          "lckanjgmijmafbedllaakclkaicjfmnk" # ClearURLs
          "oofgbpoabipfcfjapgnbbjjaenockbdp" # SetupVPN
        ];
      };
    };

    environment.systemPackages = with pkgs; [
      # Productivity
      calibre
      simple-scan
      gscan2pdf
      libreoffice

      # Graphics
      drawing
      gimp3
      handbrake
      inkscape
      xournalpp

      # Internet
      google-chrome
      linux-wifi-hotspot
      openfortivpn
      teams-for-linux
      thunderbird
      whatsapp-for-linux
      zoom-us

      # Utilities
      hunspell
      hunspellDicts.en_US-large
      hyphen
      popsicle
    ];

    # Dictionaries
    environment = {
      pathsToLink = [
        "/share/hunspell"
        "/share/myspell"
        "/share/hyphen"
      ];

      variables."DICPATH" = "/run/current-system/sw/share/hunspell:/run/current-system/sw/share/hyphen";
    };

    user = {
      # Persisted Files
      persist.files = [
        ".config/gscan2pdfrc"
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
        ".config/whatsapp-for-linux"
        ".local/share/data"
        ".local/share/onlyoffice"
        ".local/share/whatsapp-for-linux"
        ".cache/gimp"
        ".cache/thunderbird"
        ".cache/google-chrome"
        ".cache/whatsapp-for-linux"
        ".cache/zoom"
      ];

      homeConfig = {
        # File Associations
        xdg.mimeApps.defaultApplications = util.build.mime {
          office = [ "onlyoffice-desktopeditors.desktop" ];
        };

        home.file = {
          # Document Templates
          "Templates" = rec {
            source = files.templates;
            target = ".init-templates";
            onChange = ''
              rm -rf ~/Templates
              cp -rL ~/${target} ~/Templates
              chmod -R 0777 ~/Templates
            '';
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

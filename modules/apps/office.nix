## Office Environment Configuration ##
{config, ...}: let
  inherit (config) util;
  inherit (config.flake) files;
in {
  flake.modules = {
    nixos.office = {pkgs, ...}: {
      environment = {
        systemPackages = with pkgs; [
          calibre
          gscan2pdf
          keepassxc
          libreoffice
          onlyoffice-desktopeditors
          pdfarranger
          simple-scan
          gimp3
          handbrake
          inkscape
          xournalpp
          hunspell
          hunspellDicts.en_US-large
          hyphen
        ];
        variables."DICPATH" = "/run/current-system/sw/share/hunspell:/run/current-system/sw/share/hyphen";
        pathsToLink = [
          "/share/hunspell"
          "/share/myspell"
          "/share/hyphen"
        ];
      };
    };

    homeManager.office = {pkgs, ...}: {
      xdg.mimeApps.defaultApplications = util.build.mime {
        office = ["onlyoffice-desktopeditors.desktop"];
        password = ["org.keepassxc.KeePassXC.desktop"];
      };

      programs.keepassxc.enable = true;

      home = {
        persist = {
          files = [".config/gscan2pdfrc"];
          directories = [
            ".calibre"
            ".config/calibre"
            ".config/GIMP"
            ".cache/gimp"
            ".config/inkscape"
            ".config/keepassxc"
            ".cache/keepassxc"
            ".config/libreoffice"
            ".config/onlyoffice"
            ".local/share/onlyoffice"
            ".local/share/data"
          ];
        };

        file = {
          "Templates" = rec {
            source = files.templates;
            target = ".init-templates";
            onChange = ''
              rm -rf ~/Templates
              cp -rL ~/${target} ~/Templates
              chmod -R 0777 ~/Templates
            '';
          };
          ".local/share/fonts" = {
            source = "${pkgs.custom.fonts}/share/fonts";
            recursive = true;
          };
        };
      };
    };
  };
}

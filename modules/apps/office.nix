## Shared Office Environment ##
{config, ...}: let
  inherit (config.flake) files;
in {
  flake.modules = {
    # Dictionaries
    nixos.office = {pkgs, ...}: {
      environment = {
        systemPackages = with pkgs; [
          hunspell
          hunspellDicts.en_US-large
          hyphen
        ];
        sessionVariables."DICPATH" = "/run/current-system/sw/share/hunspell:/run/current-system/sw/share/hyphen";
        pathsToLink = [
          "/share/hunspell"
          "/share/myspell"
          "/share/hyphen"
        ];
      };
    };

    homeManager.office = {pkgs, ...}: {
      home = {
        persist.directories = [".local/share/data"];
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

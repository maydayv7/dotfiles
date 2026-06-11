## Logseq Configuration ##
{config, ...}: let
  inherit (config) util;
  inherit (config.flake) files;
in {
  flake.modules = {
    nixos.notes = {pkgs, ...}: {
      environment.systemPackages = [pkgs.logseq];
    };

    homeManager.notes = {
      config,
      lib,
      ...
    }: let
      mutable = {
        mutable = true;
        force = true;
      };
      inherit (config.apps.logseq) style;
    in {
      home = {
        persist.directories = [
          ".logseq"
          ".config/Logseq"
        ];

        file = with files.logseq;
          {
            ".config/logseq/configs.edn".text = "{:window/native-titlebar? true}";
            ".logseq/preferences.json" =
              {
                text = prefs;
              }
              // mutable;
            ".logseq/config/config.edn".text =
              if style != ""
              then ''{:custom-css-url "@import ${style};"}''
              else lib.mkDefault "";
          }
          // util.map.folder {
            directory = settings;
            path = ".logseq/settings";
            extension = ".json";
            apply = text: {inherit text;} // mutable;
            replace = {
              placeholders = ["@bg"];
              values = [config.lib.stylix.colors.base00];
            };
          };
      };
    };
  };
}

{
  config,
  lib,
  util,
  pkgs,
  files,
  ...
}:
let
  enable = builtins.elem "notes" config.apps.list;
  mutable = {
    mutable = true;
    force = true;
  };
in
{
  ## Logseq Configuration ##
  config = lib.mkIf enable {
    environment.systemPackages = [ pkgs.logseq ];

    user = {
      persist.directories = [
        ".logseq"
        ".config/Logseq"
      ];

      homeConfig.home.file =
        with files.logseq;
        {
          ".config/logseq/configs.edn".text = ''{:window/native-titlebar? true}'';
          ".logseq/preferences.json" = {
            text = prefs;
          } // mutable;
        }
        // util.map.folder {
          directory = settings;
          path = ".logseq/settings";
          extension = ".json";
          apply = text: { inherit text; } // mutable;
          replace = {
            placeholders = [ "@bg" ];
            values = [ config.lib.stylix.colors.base00 ];
          };
        };
    };
  };
}

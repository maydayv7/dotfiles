## Logseq Configuration ##
{config, ...}: let
  inherit (config) util;
  inherit (config.flake) files;
in {
  flake.modules.homeManager.notes = {
    config,
    lib,
    pkgs,
    osConfig ? {},
    ...
  }: let
    mutable = {
      mutable = true;
      force = true;
    };

    isGnome = osConfig.services.desktopManager.gnome.enable or false;
    isHyprland = osConfig.programs.hyprland.enable or false;
    style =
      if isGnome
      then "url('https://cdn.jsdelivr.net/gh/sansui233/logseq-bonofix-theme/custom.css')"
      else if isHyprland
      then "url('https://logseq.catppuccin.com/ctp-${config.catppuccin.flavor}.css')"
      else "";
  in {
    config.home = {
      packages = [pkgs.logseq];
      persist.directories = [
        ".logseq"
        ".config/Logseq"
      ];

      file = with files.logseq;
        {
          ".config/logseq/configs.edn".text = "{:window/native-titlebar? true}";
          ".logseq/preferences.json" = {text = prefs;} // mutable;
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
}

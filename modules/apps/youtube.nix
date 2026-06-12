## YT Configuration ##
{config, ...}: let
  inherit (config.flake) files;
in {
  flake.modules.homeManager.youtube = {
    config,
    lib,
    pkgs,
    osConfig ? {},
    ...
  }: let
    isHyprland = osConfig.programs.hyprland.enable or false;
    inherit (config.apps.ytmusic) style;
  in {
    options.apps.ytmusic.style = lib.mkOption {
      description = "YouTube Music CSS";
      type = lib.types.str;
      default = "";
    };

    config = {
      # Desktop-specific theme
      apps.ytmusic.style = lib.mkIf isHyprland
        "@import url('https://youtubemusic.catppuccin.com/src/${config.catppuccin.flavor}.css');";

      home = {
        packages = with pkgs; [
          pear-desktop
          youtube-tui
          yt-dlp
        ];

        persist.directories = [
          ".config/pear-desktop"
          ".config/youtube-tui"
          ".local/share/youtube-tui"
        ];

        file.".config/pear-desktop/config.json" = {
          text = lib.replaceStrings ["@theme"] [(builtins.toFile "style.css" style)] files.youtube;
          mutable = true;
          force = true;
        };
      };
    };
  };
}

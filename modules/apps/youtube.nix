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
    style =
      if isHyprland
      then "@import url('https://youtubemusic.catppuccin.com/src/${config.catppuccin.flavor}.css');"
      else "";
  in {
    config.home = {
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
}

## YT Configuration ##
{config, ...}: let
  inherit (config.flake) files;
in {
  flake.modules = {
    nixos.youtube = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        youtube-music
        youtube-tui
        yt-dlp
      ];
    };

    homeManager.youtube = {
      lib,
      osConfig ? null,
      ...
    }: let
      style =
        if osConfig != null
        then osConfig.apps.ytmusic.style
        else "";
    in {
      home = {
        persist.directories = [
          ".config/YouTube Music"
          ".config/youtube-tui"
          ".local/share/youtube-tui"
        ];

        file.".config/YouTube Music/config.json" = {
          text = lib.replaceStrings ["@theme"] [(builtins.toFile "style.css" style)] files.youtube;
          mutable = true;
          force = true;
        };
      };
    };
  };
}

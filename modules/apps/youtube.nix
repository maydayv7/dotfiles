## YT Configuration ##
{config, ...}: let
  inherit (config.flake) files;
in {
  flake.modules.homeManager.youtube = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (config.apps.ytmusic) style;
  in {
    options.apps.ytmusic.style = lib.mkOption {
      description = "YouTube Music CSS";
      type = lib.types.str;
      default = "";
    };

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

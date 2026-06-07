## YT Configuration ##
{ config, ... }:
let
  files = config.flake.files;
in
{
  flake.modules = {
    nixos.youtube =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          youtube-music
          youtube-tui
          yt-dlp
        ];
      };

    homeManager.youtube =
      { lib, ... }:
      {
        home = {
          persist.directories = [
            ".config/YouTube Music"
            ".config/youtube-tui"
            ".local/share/youtube-tui"
          ];

          file.".config/YouTube Music/config.json" = {
            text =
              lib.replaceStrings
                [ "@theme" ]
                [ (builtins.toFile "style.css" "") ]
                files.youtube;
            mutable = true;
            force = true;
          };
        };
      };
  };
}

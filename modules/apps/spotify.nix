{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  enable = builtins.elem "spotify" config.apps.list;
  spice = inputs.spotify.legacyPackages.${pkgs.system};
in {
  ## Spotify Configuration ##
  config = lib.mkIf enable {
    environment.systemPackages = with pkgs; [spotify spicetify-cli];

    user = {
      persist.directories = [".config/spotify" ".cache/spotify"];
      homeConfig = {
        imports = [inputs.spotify.homeManagerModules.default];
        programs.spicetify = {
          enable = true;

          # Player Improvements
          enabledCustomApps = with spice.apps; [
            betterLibrary
            localFiles
            newReleases
          ];

          enabledExtensions = with spice.extensions; [
            beautifulLyrics
            goToSong
            history
            loopyLoop
            playNext
            popupLyrics
            seekSong
            showQueueDuration
            volumePercentage
          ];
        };
      };
    };
  };
}

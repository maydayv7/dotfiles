## Spotify Configuration ##
{inputs, ...}: {
  flake.modules.homeManager.spotify = {pkgs, ...}: {
    imports = [inputs.spicetify.homeManagerModules.default];
    home = {
      packages = [pkgs.spot];
      persist.directories = [
        ".config/spotify"
        ".cache/spotify"
        ".cache/spot"
      ];
    };

    programs.spicetify = {
      enable = true;

      # Player Improvements
      enabledCustomApps = with pkgs.spicetify.apps; [
        betterLibrary
        localFiles
        newReleases
      ];

      enabledExtensions = with pkgs.spicetify.extensions; [
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
}

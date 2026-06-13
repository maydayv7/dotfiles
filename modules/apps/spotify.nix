## Spotify Configuration ##
{inputs, ...}: {
  flake.modules.homeManager.spotify = {pkgs, ...}: {
    imports = [inputs.spicetify.homeManagerModules.default];
    home.persist.directories = [
      ".config/spotify"
      ".cache/spotify"
    ];

    programs.spicetify = {
      enable = true;

      # Player Improvements
      enabledCustomApps = with pkgs.spicetify.apps; [
        betterLibrary
        localFiles
        newReleases
      ];

      enabledExtensions = with pkgs.spicetify.extensions; [
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

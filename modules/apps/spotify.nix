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

          # Theming
          theme =
            spice.themes.sleek
            // {
              additionalCss = "* { font-family: ${config.stylix.fonts.sansSerif.name} !important } ";
            };

          colorScheme = "custom";
          customColorScheme = with config.lib.stylix.colors; {
            "text" = "${base07}";
            "subtext" = "${base05}";
            "nav-active-text" = "${bright-green}";
            "main" = "${base00}";
            "sidebar" = "${base00}";
            "player" = "${base00}";
            "card" = "${base00}";
            "shadow" = "${base02}";
            "main-secondary" = "${base01}";
            "button" = "${base07}";
            "button-secondary" = "${green}";
            "button-active" = "${base0D}";
            "button-disabled" = "${base0D}";
            "nav-active" = "${base0D}";
            "play-button" = "${green}";
            "tab-active" = "${yellow}";
            "notification" = "${base07}";
            "notification-error" = "${orange}";
            "playback-bar" = "${bright-green}";
            "misc" = "${bright-green}";
          };

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

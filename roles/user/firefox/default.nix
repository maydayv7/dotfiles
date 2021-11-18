{ lib, inputs, pkgs, ... }:
{
  ## Firefox Browser Configuration ##
  # Profile
  programs.firefox =
  {
    enable = true;
    profiles.v7 =
    {
      settings = 
      {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.uidensity" = 0;
        "svg.context-properties.content.enabled" = true;
      };
    };
  };

  # Theme
  home.file.".mozilla/firefox/v7/chrome/userChrome.css".text = ''@import "${inputs.firefox}/userChrome.css";'';
}

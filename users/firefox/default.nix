{ lib, pkgs, ... }:
{
  ## Firefox Browser Configuration ##
  home.packages = with pkgs;
  [
    custom.gnome-firefox
    firefox
  ];
  
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
  home.file.".mozilla/firefox/v7/chrome/userChrome.css".text = ''@import "${pkgs.custom.gnome-firefox}/firefox-gnome-theme/userChrome.css";'';
}

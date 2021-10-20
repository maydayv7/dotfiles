{ lib, ... }:
{
  ## Firefox Browser Configuration ##
  programs.firefox =
  {
    enable = true;
    profiles.v7 =
    {
      settings = 
      {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.download.dir" = "/home/v7/Downloads";
      };
    };
  };
  
  # Theme
  home.file =
  {
    ".mozilla/firefox/v7/chrome".source = ./theme;
  };
}

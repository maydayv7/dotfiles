{ config, username, lib, ... }:
let
  enable = (builtins.elem "firefox" config.apps.list);
in rec
{
  ## Firefox Browser Configuration ##
  config =
  {
    home-manager.users."${username}".programs.firefox =
    {
      enable = true;

      # Profile
      profiles."${username}" =
      {
        settings = 
        {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "browser.uidensity" = 0;
          "svg.context-properties.content.enabled" = true;
          "mozilla.widget.use-argb-visuals" = true;
        };
      };
    };
  };
}

{ config, username, lib, inputs, pkgs, ... }:
let
  enable = config.apps.firefox.enable;
  desktop = config.gui.desktop;
in rec
{
  options.apps.firefox.enable = lib.mkEnableOption "Enable Firefox Web Browser";

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

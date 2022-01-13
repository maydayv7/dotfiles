{ config, lib, pkgs, ... }:
let
  enable = (builtins.elem "firefox" config.apps.list);
  username = config.user.name;
in rec {
  ## Firefox Browser Configuration ##
  config = lib.mkIf enable {
    environment.systemPackages = [ pkgs.firefox ];

    # Profile
    user.home.programs.firefox = {
      enable = true;
      profiles.${username}.settings = {
        ## Flags
        # Features
        "browser.search.openintab" = true;
        "layout.spellcheckDefault" = 2;

        # Theming
        "devtools.theme" = "dark";
        "browser.shell.checkDefaultBrowser" = false;
        "browser.uidensity" = 0;
        "mozilla.widget.use-argb-visuals" = true;
        "svg.context-properties.content.enabled" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        # Telemetry
        "beacon.enabled" = false;
        "browser.send_pings" = false;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "dom.battery.enabled" = false;
        "dom.gamepad.enabled" = false;
        "experiments.enabled" = false;
        "experiments.manifest.uri" = "";
        "experiments.supported" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
      };
    };
  };
}

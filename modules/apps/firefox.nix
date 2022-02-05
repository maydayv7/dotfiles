{ config, lib, pkgs, files, ... }:
let
  inherit (lib) mkIf util;
  enable = builtins.elem "firefox" config.apps.list;
in {
  ## Firefox Browser Configuration ##
  config = mkIf enable {
    environment.systemPackages = [ pkgs.firefox ];
    user.persist.dirs = [ ".cache/mozilla/firefox" ".mozilla/firefox" ];

    user.home = {
      # File Associations
      xdg.mimeApps.defaultApplications = util.xdg.mime (import files.xdg.mime) {
        browser = [ "firefox.desktop" ];
      };

      # Profile
      programs.firefox = {
        enable = true;
        profiles.default.settings = {
          ## Flags
          # Features
          "browser.search.openintab" = true;
          "layout.spellcheckDefault" = 2;

          # Theming
          "browser.shell.checkDefaultBrowser" = false;
          "browser.uidensity" = 0;
          "devtools.theme" = "dark";
          "layers.acceleration.force-enabled" = true;
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
  };
}

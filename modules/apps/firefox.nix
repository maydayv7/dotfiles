{
  config,
  lib,
  pkgs,
  files,
  ...
}: let
  inherit (lib) mkIf util;
  enable = builtins.elem "firefox" config.apps.list;
in {
  ## Firefox Browser Configuration ##
  config = mkIf enable {
    environment.systemPackages = [pkgs.firefox];
    user.persist.dirs = [".cache/mozilla/firefox" ".mozilla/firefox"];

    user.home = {
      # File Associations
      xdg.mimeApps.defaultApplications = util.xdg.mime (import files.xdg.mime) {
        browser = ["firefox.desktop"];
      };

      # Profile
      programs.firefox = {
        enable = true;
        profiles.default.settings = {
          ## Flags
          # General
          "browser.aboutConfig.showWarning" = false;
          "browser.shell.checkDefaultBrowser" = false;
          "browser.toolbars.bookmarks.visibility" = "always";
          "browser.urlbar.showSearchSuggestionsFirst" = false;

          # Features
          "browser.search.openintab" = true;
          "layout.spellcheckDefault" = 2;

          # New Tab
          "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.newtabpage.activity-stream.showSearch" = true;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" =
            false;
          "browser.newtabpage.activity-stream.feeds.section.highlights.includePocket" =
            false;

          # Theming
          "browser.uidensity" = 0;
          "devtools.theme" = "dark";
          "layers.acceleration.force-enabled" = true;
          "mozilla.widget.use-argb-visuals" = true;
          "svg.context-properties.content.enabled" = true;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

          # Passwords
          "signon.autofillForms" = false;
          "signon.rememberSignons" = false;
          "signon.generation.enabled" = false;
          "signon.management.page.breach-alerts.enabled" = false;

          # Extensions
          "extensions.pocket.enabled" = false;
          "extensions.htmlaboutaddons.inline-options.enabled" = false;
          "extensions.htmlaboutaddons.recommendations.enabled" = false;

          # Telemetry
          "app.shield.optoutstudies.enable" = false;
          "beacon.enabled" = false;
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.ping-centre.telemetry" = false;
          "browser.send_pings" = false;
          "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
          "datareporting.healthreport.service.enabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "dom.battery.enabled" = false;
          "dom.gamepad.enabled" = false;
          "experiments.enabled" = false;
          "experiments.manifest.uri" = "";
          "experiments.supported" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.reportingpolicy.firstRun" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
        };
      };
    };
  };
}

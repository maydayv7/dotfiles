{
  config,
  lib,
  util,
  pkgs,
  files,
  ...
}: let
  enable = builtins.elem "firefox" config.apps.list;
in {
  ## Firefox Browser Configuration ##
  config = lib.mkIf enable {
    environment = {
      systemPackages = [pkgs.firefox];
      sessionVariables.MOZ_USE_XINPUT2 = "1";
    };

    user = {
      persist.directories = [".cache/mozilla/firefox" ".mozilla/firefox"];
      homeConfig = {
        # File Associations
        xdg.mimeApps.defaultApplications = util.build.mime files.xdg.mime {
          browser = ["firefox.desktop"];
        };

        # Profile
        programs.firefox = {
          enable = true;
          policies = {
            # Policies
            DisableTelemetry = true;
            DisableFirefoxStudies = true;
            DisablePocket = true;
            EnableTrackingProtection = {
              Value = true;
              Locked = true;
              Cryptomining = true;
              Fingerprinting = true;
            };

            # Extensions
            ExtensionSettings = let
              extension = shortId: uuid: {
                name = uuid;
                value = {
                  installation_mode = "normal_installed";
                  install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
                };
              };
            in
              builtins.listToAttrs [
                (extension "clearurls" "{74145f27-f039-47ce-a470-a662b129930a}")
                (extension "setupvpn" "@setupvpncom")
                (extension "tabliss" "extension@tabliss.io")
                (extension "uaswitcher" "user-agent-switcher@ninetailed.ninja")
                (extension "ublock-origin" "uBlock0@raymondhill.net")
              ];
          };

          profiles.default.settings = {
            ## Flags
            # General
            "browser.disableResetPrompt" = true;
            "browser.onboarding.enabled" = false;
            "browser.aboutConfig.showWarning" = false;
            "browser.shell.checkDefaultBrowser" = false;
            "browser.sessionstore.interval" = "1800000";
            "browser.toolbars.bookmarks.visibility" = "always";
            "browser.urlbar.showSearchSuggestionsFirst" = false;
            "browser.urlbar.speculativeConnect.enabled" = false;
            "browser.urlbar.dnsResolveSingleWordsAfterSearch" = 0;

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

            # Security
            "security.family_safety.mode" = 0;
            "security.pki.sha1_enforcement_level" = 1;
            "security.tls.enable_0rtt_data" = false;

            # Reports
            "breakpad.reportURL" = "";
            "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
            "browser.tabs.crashReporting.sendReport" = false;
            "datareporting.healthreport.service.enabled" = false;
            "datareporting.healthreport.uploadEnabled" = false;
            "datareporting.policy.dataSubmissionEnabled" = false;
          };
        };
      };
    };
  };
}

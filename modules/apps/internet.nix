## Internet Apps Configuration ##
{config, ...}: let
  inherit (config) util;
in {
  flake.modules.homeManager.internet = {
    config,
    lib,
    pkgs,
    ...
  }: {
    programs = {
      # Browser
      brave = {
        enable = true;
        extensions =
          [
            "djflhoibgkdhkhhcedjiklpkjnoahfmg" # User Agent Switcher
            "lckanjgmijmafbedllaakclkaicjfmnk" # ClearURLs
            "oofgbpoabipfcfjapgnbbjjaenockbdp" # SetupVPN
            "jghecgabfgfdldnmbfkhmffcabddioke" # Volume Booster
            "jaioibhbkffompljnnipmpkeafhpicpd" # Tab Auto Refresh
            "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
            "clngdbkpkpeebahjckkjfobafhncgmne" # Stylus
          ]
          # KeePassXC
          ++ lib.optional config.programs.keepassxc.enable "oboonakemofpalcgghocfoadofidjkkk";
        nativeMessagingHosts =
          lib.optional config.programs.keepassxc.enable
          (pkgs.writeTextDir
            "etc/chromium/native-messaging-hosts/org.keepassxc.keepassxc_browser.json"
            (builtins.toJSON {
              name = "org.keepassxc.keepassxc_browser";
              description = "KeePassXC integration with native messaging support";
              path = "${pkgs.keepassxc}/bin/keepassxc-proxy";
              type = "stdio";
              allowed_origins = [
                "chrome-extension://oboonakemofpalcgghocfoadofidjkkk/"
                "chrome-extension://pdffhmdngciaglkoonimfcmckehcpafo/"
              ];
            }));
      };

      # Mail Client
      thunderbird = {
        enable = true;
        profiles.default = {
          isDefault = true;
          extensions = [pkgs.custom.thunderbird-tools-ng];
          settings."extensions.autoDisableScopes" = 0;
        };
      };
    };

    xdg.mimeApps.defaultApplications = util.build.mime {
      mail = ["thunderbird.desktop"];
    };

    home = {
      packages = with pkgs; [
        linux-wifi-hotspot
        openfortivpn
        teams-for-linux
        zapzap
        zoom-us
      ];

      persist = {
        files = [".config/zoomus.conf"];
        directories = [
          ".config/BraveSoftware"
          ".cache/BraveSoftware"
          ".config/teams-for-linux"
          ".thunderbird"
          ".cache/thunderbird"
          ".config/ZapZap"
          ".local/share/ZapZap"
          ".cache/ZapZap"
          ".zoom"
          ".cache/zoom"
        ];
      };
    };
  };
}

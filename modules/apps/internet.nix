## Internet Apps Configuration ##
{config, ...}: let
  inherit (config) util;
in {
  flake.modules.homeManager.internet = {pkgs, ...}: {
    programs = {
      # Browser
      brave = {
        enable = true;
        extensions = [
          "cjpalhdlnbpafiamejdnhcphjbkeiagm" # UBlock Origin
          "djflhoibgkdhkhhcedjiklpkjnoahfmg" # User Agent Switcher
          "lckanjgmijmafbedllaakclkaicjfmnk" # ClearURLs
          "oofgbpoabipfcfjapgnbbjjaenockbdp" # SetupVPN
          "jghecgabfgfdldnmbfkhmffcabddioke" # Volume Booster
          "jaioibhbkffompljnnipmpkeafhpicpd" # Tab Auto Refresh
          "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
          "clngdbkpkpeebahjckkjfobafhncgmne" # Stylus
        ];
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

    home.packages = with pkgs; [
      karere
      linux-wifi-hotspot
      openfortivpn
      teams-for-linux
      zoom-us
    ];

    home.persist = {
      files = [".config/zoomus.conf"];
      directories = [
        ".config/BraveSoftware"
        ".cache/BraveSoftware"
        ".thunderbird"
        ".cache/thunderbird"
        ".config/karere"
        ".local/share/karere"
        ".cache/karere"
        ".zoom"
        ".cache/zoom"
      ];
    };
  };
}

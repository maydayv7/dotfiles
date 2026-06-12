## Internet Apps Configuration ##
_: {
  flake.modules.homeManager.internet = {pkgs, ...}: {
    programs.chromium = {
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

    home.packages = with pkgs; [
      brave
      karere
      linux-wifi-hotspot
      openfortivpn
      teams-for-linux
      thunderbird
      zoom-us
    ];

    home.persist = {
      files = [".config/zoomus.conf"];
      directories = [
        ".config/BraveSoftware"
        ".cache/BraveSoftware"
        ".config/chromium"
        ".cache/chromium"
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

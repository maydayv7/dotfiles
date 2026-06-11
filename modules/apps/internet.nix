## Internet Apps Configuration ##
_: {
  flake.modules = {
    nixos.internet = {pkgs, ...}: {
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

      environment.systemPackages = with pkgs; [
        brave
        linux-wifi-hotspot
        openfortivpn
        teams-for-linux
        thunderbird
        wasistlos
        zoom-us
      ];
    };

    homeManager.internet = _: {
      home.persist = {
        files = [".config/zoomus.conf"];
        directories = [
          ".config/BraveSoftware"
          ".cache/BraveSoftware"
          ".thunderbird"
          ".cache/thunderbird"
          ".config/wasistlos"
          ".local/share/wasistlos"
          ".cache/wasistlos"
          ".zoom"
          ".cache/zoom"
        ];
      };
    };
  };
}

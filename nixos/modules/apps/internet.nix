## Internet Apps Configuration ##
{ ... }:
{
  flake.modules = {
    nixos.internet =
      { pkgs, ... }:
      {
        programs.chromium = {
          enable = true;
          extensions = [
            "cjpalhdlnbpafiamejdnhcphjbkeiagm"
            "djflhoibgkdhkhhcedjiklpkjnoahfmg"
            "lckanjgmijmafbedllaakclkaicjfmnk"
            "oofgbpoabipfcfjapgnbbjjaenockbdp"
            "jghecgabfgfdldnmbfkhmffcabddioke"
            "jaioibhbkffompljnnipmpkeafhpicpd"
            "eimadpbcbfnmbkopoojfekhnkhdbieeh"
            "clngdbkpkpeebahjckkjfobafhncgmne"
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

    homeManager.internet = { ... }: {
      home.persist = {
        files = [ ".config/zoomus.conf" ];
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

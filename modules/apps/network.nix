## Network Utilities ##
{
  flake.modules = {
    nixos.network = {pkgs, ...}: {
      programs.wireshark = {
        enable = true;
        package = pkgs.wireshark;
        dumpcap.enable = true;
        usbmon.enable = true;
      };
    };

    homeManager.network = {pkgs, ...}: {
      home = {
        persist.directories = [".config/wireshark"];
        packages = with pkgs; [
          cloudflared
          dig
          linux-wifi-hotspot
        ];
      };
    };
  };
}

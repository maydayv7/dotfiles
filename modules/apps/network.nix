## Network Utilities ##
{
  flake.modules.homeManager.network = {pkgs, ...}: {
    home.packages = with pkgs; [
      cloudflared
      dig
      linux-wifi-hotspot
      openfortivpn
    ];
  };
}

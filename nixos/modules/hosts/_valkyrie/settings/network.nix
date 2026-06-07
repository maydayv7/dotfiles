{ config, ... }:
{
  ## VPN
  # ? # Run 'warp-cli registration new' for initial setup
  services.cloudflare-warp = {
    enable = true;
    openFirewall = true;
  };

  environment.persist.directories = [ config.services.cloudflare-warp.rootDir ];
  user.homeConfig.home.persist.directories = [ ".local/share/cloudflare-warp-gui" ];

  # Development
  networking.firewall = {
    allowedUDPPorts = [ 7777 ];
    allowedTCPPorts = [ 7777 ];
  };
}

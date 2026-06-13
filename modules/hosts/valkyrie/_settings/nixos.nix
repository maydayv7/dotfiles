{
  config,
  pkgs,
  ...
}: {
  ## VPN
  # ? # Run 'warp-cli registration new' for initial setup
  services.cloudflare-warp = {
    enable = true;
    openFirewall = true;
  };

  environment.persist.directories = [config.services.cloudflare-warp.rootDir];

  # Development
  environment.systemPackages = with pkgs; [
    github-copilot-cli
  ];

  networking.firewall = {
    allowedUDPPorts = [7777];
    allowedTCPPorts = [7777];
  };
}

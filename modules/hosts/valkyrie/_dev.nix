## Development
_: {
  nixos = {
    config,
    pkgs,
    ...
  }: {
    # VPN
    services.cloudflare-warp = {
      enable = true;
      openFirewall = true;
    };

    # VPN Tunnel
    services.tailscale = {
      enable = true;
      openFirewall = true;
      #authKeyFile = config.sops.secrets."tailscale.secret".path;
    };

    environment = {
      persist.directories = [
        "/var/lib/tailscale"
        config.services.cloudflare-warp.rootDir
      ];

      # Tools
      systemPackages = with pkgs; [
        cloudflared
        gcc
        (mongodb-compass.overrideAttrs (oldAttrs: {
          buildCommand =
            (oldAttrs.buildCommand or "")
            + ''
              wrapProgram $out/bin/mongodb-compass \
                --add-flags "--ignore-additional-command-line-flags" \
                --add-flags "--password-store=gnome-libsecret"
            '';
        }))

        # Node
        nodejs
        npm-check-updates
        pnpm
      ];
    };

    networking.firewall = {
      allowedUDPPorts = [7777];
      allowedTCPPorts = [7777];
    };
  };

  home = {config, ...}: {
    programs.ssh.includes = [config.sops.secrets."ssh-config.secret".path];

    home = {
      persist.directories = [
        ".mongodb"
        ".npm"
        ".config/rog"
        ".config/MongoDB Compass"
        ".local/share/cloudflare-warp-gui"
      ];

      # NPM
      sessionPath = ["$HOME/.npm/packages/bin"];
      file.".npmrc".text = ''
        prefix=''${HOME}/.npm/packages
        cache=''${HOME}/.npm/cache
      '';
    };
  };
}

{
  config,
  lib,
  ...
}: let
  inherit (config.apps.git) hosting;
in {
  options.apps.git.hosting = lib.mkEnableOption "Enable Gitea Code Hosting";

  config = lib.mkIf hosting {
    # User Configuration
    user.groups = ["gitea"];
    users.users.git = {
      useDefaultShell = true;
      home = "/var/lib/gitea";
      group = "gitea";
      isSystemUser = true;
    };

    # Gitea Settings
    services.gitea = {
      enable = true;
      lfs.enable = true;

      # Security
      user = "git";
      database.user = "git";
      cookieSecure = true;
      disableRegistration = true;

      # Repository
      appName = "@maydayv7 Code Hosting";
      domain = "maydayv7.io";
      rootUrl = "https://code.maydayv7.io";
      httpPort = 7000;
      settings.ui.DEFAULT_THEME = "arc-green";
    };

    # NGINX Secured Reverse Proxy
    environment.persist.dirs = ["/srv"];
    networking.firewall = {
      allowedUDPPorts = [7000];
      allowedTCPPorts = [80 443 7000];
    };

    security.acme = {
      acceptTerms = true;
      email = "accounts+acme@maydayv7.io";
    };

    services.nginx = {
      enable = true;

      # Security
      clientMaxBodySize = "128k";
      commonHttpConfig = ''
        client_body_buffer_size 4k;
        large_client_header_buffers 2 4k;
        map $sent_http_content_type $expires {
          default                off;
          text/html              10m;
          text/css               max;
          application/javascript max;
          application/pdf        max;
          ~image/                max;
        }
      '';

      # Recommended Defaults
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      # Code Hosting
      virtualHosts."code.maydayv7.io" = {
        forceSSL = true;
        enableACME = true;
        root = "/srv/www/code.maydayv7.io";
        locations."/".proxyPass = "http://127.0.0.1:7000";
      };
    };
  };
}

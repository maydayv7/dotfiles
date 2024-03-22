{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;
  inherit (config.apps.git.hosting) enable domain secret;
  opt = config.apps.git.hosting;
in {
  options.apps.git.hosting = {
    enable = mkEnableOption "Enable Gitea Code Hosting";
    domain = mkOption {
      description = "Website Domain Name";
      type = types.str;
      default = "";
      example = "maydayv7.net";
    };
    secret = mkOption {
      description = "Path to Cloudfare Authentication Credentials";
      type = types.str;
      default = "";
    };
  };

  config = mkIf enable {
    assertions = [
      {
        assertion = domain != "";
        message = opt.domain.description + " must be set";
      }
      {
        assertion = secret != "";
        message = opt.secret.description + " must be set";
      }
    ];

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
      inherit domain;
      appName = "Code Hosting";
      rootUrl = "https://${domain}";
      httpPort = 7000;
      settings.ui.DEFAULT_THEME = "arc-green";
    };

    # NGINX Secured Reverse Proxy
    environment.persist.directories = ["/srv"];
    networking.firewall = {
      allowedUDPPorts = [7000];
      allowedTCPPorts = [80 443 7000];
    };

    security.acme = {
      acceptTerms = true;
      email = "accounts+acme@${domain}";
      certs."${domain}" = {
        group = "nginx";
        email = "admin@${domain}";
        dnsProvider = "cloudflare";
        credentialsFile = secret;
        extraLegoFlags = ["--dns.resolvers=8.8.8.8:53"];
      };
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
      virtualHosts."${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";
        root = "/srv/www/${domain}";
        locations."/".proxyPass = "http://127.0.0.1:7000";
      };
    };
  };
}

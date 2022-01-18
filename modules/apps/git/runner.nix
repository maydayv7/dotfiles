{ config, lib, pkgs, files, ... }:
let
  inherit (lib) mkIf mkMerge mkOption types util;
  inherit (config.apps.git) runner;
  inherit (config.sops) secrets;
in {
  options.apps.git.runner = mkOption {
    description = "Support for 'git' Runners";
    type = types.nullOr (types.enum [ "github" "gitlab" ]);
    default = null;
  };

  ## Runner Configuration ##
  config = mkIf (runner != null) (mkMerge [
    {
      # Secrets
      sops.secrets = util.map.secrets ./secrets false;
    }

    (mkIf (runner == "github") {
      # GitHub Runner
      environment.systemPackages = [ pkgs.act ];
      services.github-runner = {
        enable = true;
        url = files.path.repo;
        extraLabels = [ "self" ];
        tokenFile = secrets."github-runner.secret".path;
      };
    })

    (mkIf (runner == "gitlab") {
      # Docker Support
      boot.kernel.sysctl."net.ipv4.ip_forward" = true;
      virtualisation.docker.enable = true;

      # GitLab Runner
      services.gitlab-runner = {
        enable = true;
        services.default = {
          dockerImage = "alpine";
          tagList = [ "self" ];
          registrationConfigFile = secrets."gitlab-runner.secret".path;
        };
      };
    })
  ]);
}

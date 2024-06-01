{
  config,
  options,
  lib,
  pkgs,
  files,
  ...
}: let
  inherit (lib) mkIf mkMerge mkOption types;
  inherit (config.apps.git) runner;
in {
  options.apps.git.runner = {
    support = mkOption {
      description = "Support for 'git' Runners";
      type = types.nullOr (types.enum ["github" "gitlab"]);
      default = null;
    };
    secret = mkOption {
      description = "Path to Secret for 'git' Runner";
      type = types.str;
      default = "";
    };
  };

  ## Runner Configuration ##
  config = mkIf (runner.support != null) (mkMerge [
    {
      assertions = [
        {
          assertion = runner.secret != "";
          message = options.apps.git.runner.secret.description + " must be set";
        }
      ];
    }
    (mkIf (runner.support == "github") {
      # GitHub Runner
      environment.systemPackages = [pkgs.act];
      services.github-runners.runner = {
        enable = true;
        url = files.path.repo;
        extraLabels = ["self"];
        tokenFile = runner.secret;
      };
    })

    (mkIf (runner.support == "gitlab") {
      # Docker Support
      boot.kernel.sysctl."net.ipv4.ip_forward" = true;
      virtualisation.docker.enable = true;

      # GitLab Runner
      services.gitlab-runner = {
        enable = true;
        services.default = {
          dockerImage = "alpine";
          tagList = ["self"];
          registrationConfigFile = runner.secret;
        };
      };
    })
  ]);
}

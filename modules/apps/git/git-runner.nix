## GitHub/GitLab CI Runner Configuration ##
{config, ...}: let
  inherit (config.flake) files;
in {
  flake.modules.nixos.git-runner = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit
      (lib)
      mkIf
      mkMerge
      mkOption
      types
      ;
    inherit (config.apps.git) runner;
  in {
    options.apps.git.runner = {
      support = mkOption {
        description = "Support for 'git' Runners";
        type = types.nullOr (
          types.enum [
            "github"
            "gitlab"
          ]
        );
        default = null;
      };
      secret = mkOption {
        description = "Path to Secret for 'git' Runner";
        type = types.str;
        default = "";
      };
    };

    config = mkIf (runner.support != null) (mkMerge [
      {
        assertions = [
          {
            assertion = runner.secret != "";
            message = "Path to Secret for 'git' Runner must be set";
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
        virtualisation.docker.enable = true;

        # GitLab Runner
        services.gitlab-runner = {
          enable = true;
          services.default = {
            dockerImage = "alpine";
            tagList = ["self"];
            authenticationTokenConfigFile = runner.secret;
          };
        };
      })
    ]);
  };
}

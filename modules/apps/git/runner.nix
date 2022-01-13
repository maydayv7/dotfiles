{ config, lib, pkgs, ... }:
let
  inherit (lib) map mkIf;
  enable = config.apps.git.runner;
  secrets = config.sops.secrets;
in
{
  ## Runner Configuration ##
  config = mkIf enable
  {
    # Secrets
    sops.secrets = map.secrets ./secrets false;

    # Docker Support
    boot.kernel.sysctl."net.ipv4.ip_forward" = true;
    virtualisation.docker.enable = true;

    # Local Runner
    environment.systemPackages = with pkgs; [ act ];
    services.gitlab-runner =
    {
      enable = true;
      services.default =
      {
        dockerImage = "alpine";
        registrationConfigFile = secrets."gitlab.runner".path;
        tagList = [ "self" ];
      };
    };
  };
}

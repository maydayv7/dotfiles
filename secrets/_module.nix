## Secrets Management ##
{
  config,
  inputs,
  ...
}: let
  inherit (config) util;
  inherit (config.flake) files;
in {
  flake.modules.nixos.secrets = {
    config,
    pkgs,
    ...
  }: let
    path = files.path.gpg;
  in {
    imports = [inputs.sops.nixosModules.sops];

    config = {
      environment = {
        persist.directories = [path];
        systemPackages = [pkgs.sops];
      };

      sops = {
        gnupg.home = path;
        secrets = let
          directory = ./. + "/${config.networking.hostName}";
        in
          util.map.secrets {directory = ./.;}
          // (
            if (builtins.pathExists directory)
            then util.map.secrets {inherit directory;}
            else {}
          );
      };
    };
  };
}

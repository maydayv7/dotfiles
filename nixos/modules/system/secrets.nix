# Secrets management via sops-nix
{ config, inputs, ... }:
let
  util = config.util;
  files = config.flake.files;
in
{
  flake.modules.nixos.secrets =
    { config, pkgs, lib, ... }:
    let
      path = files.path.gpg;
    in
    {
      imports = [ inputs.sops.nixosModules.sops ];

      config = {
        environment = {
          persist.directories = [ path ];
          systemPackages = [ pkgs.sops ];
        };

        sops = {
          gnupg.home = path;
          secrets =
            let
              directory = ../../secrets + "/${config.networking.hostName}";
            in
            util.map.secrets { directory = ../../secrets; }
            // (
              if (builtins.pathExists directory) then util.map.secrets { inherit directory; } else { }
            );
        };
      };
    };
}

# Pantheon desktop environment
{
  config,
  inputs,
  ...
}: let
  inherit (config.flake) files;
  inherit (config) util;

  main = import ./_main.nix {inherit util files inputs;};
in {
  flake.modules = {
    nixos.pantheon.imports = [
      ../_base.nix
      (main.nixos or {})
    ];

    homeManager.pantheon.imports = [
      {
        services = {
          poweralertd.enable = true;
          mpris-proxy.enable = true;
        };
        home.persist.directories = [
          ".config/autostart"
          ".local/share/gvfs-metadata"
        ];
      }
      (main.home or {})
    ];
  };
}

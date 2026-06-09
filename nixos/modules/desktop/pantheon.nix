# Pantheon desktop environment
{
  config,
  inputs,
  ...
}: let
  inherit (config.flake) files;
  inherit (config) util;
in {
  flake.modules = {
    nixos.pantheon = {
      imports = [
        ./_base.nix
        (import ./_pantheon/main.nix {inherit util files inputs;})
      ];
    };

    # Shared home-manager basics (also used by standalone configurations)
    homeManager.pantheon = _: {
      services = {
        poweralertd.enable = true;
        mpris-proxy.enable = true;
      };
      home.persist.directories = [
        ".config/autostart"
        ".local/share/gvfs-metadata"
      ];
    };
  };
}

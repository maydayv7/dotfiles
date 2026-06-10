# Niri scrollable-tiling window manager
{
  config,
  inputs,
  ...
}: let
  inherit (config.flake) files;
  inherit (config) util;
in {
  flake.modules = {
    nixos.niri = {
      imports = [
        ./_base.nix
        (import ./_niri/main.nix {inherit util files inputs;})
      ];
    };

    # Shared home-manager basics (also used by standalone configurations)
    homeManager.niri = _: {
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

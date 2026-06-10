# GNOME desktop environment
{
  config,
  inputs,
  ...
}: let
  inherit (config.flake) files;
  inherit (config) util;
in {
  flake.modules = {
    nixos.gnome = {
      imports = [
        ./_base.nix
        (import ./_gnome/main.nix {inherit util files inputs;})
      ];
    };

    # Shared home-manager basics (also used by standalone configurations)
    homeManager.gnome = _: {
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

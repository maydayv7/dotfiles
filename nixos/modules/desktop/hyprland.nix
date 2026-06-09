# Hyprland window manager
{
  config,
  inputs,
  ...
}: let
  inherit (config.flake) files;
  inherit (config) util;
in {
  flake.modules = {
    nixos.hyprland = {
      imports = [
        ./_base.nix
        (import ./_hyprland/main.nix {inherit util files inputs;})
      ];
    };

    # Shared home-manager basics (also used by standalone configurations)
    homeManager.hyprland = _: {
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

# GNOME desktop environment
{
  config,
  inputs,
  ...
}: let
  inherit (config.flake) files;
  inherit (config) util;

  main = import ./_gnome/main.nix {inherit util files inputs;};
in {
  flake.modules = {
    nixos.gnome.imports = [
      ./_base.nix
      (main.nixos or {})
    ];

    homeManager.gnome.imports = [
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

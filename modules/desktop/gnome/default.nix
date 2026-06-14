## GNOME DE ##
{config, ...}: let
  inherit (config) util;
  inherit (config.flake) files;
  inherit (config.flake.modules) nixos homeManager;

  base = import ../_base.nix {};
  main = import ./_main.nix {inherit util files;};
in {
  flake.modules = {
    nixos.gnome.imports = [
      (base.nixos or {})
      (import ./_common.nix {})
      (main.nixos or {})
      nixos.qt
      nixos.gtk
    ];

    homeManager.gnome.imports =
      [
        (base.home or {})
        (main.home or {})
        homeManager.qt
        homeManager.gtk
      ]
      ++ # Desktop Settings
      builtins.map (p: import p {inherit util files;}) (util.map.modules.list ./_settings);
  };
}

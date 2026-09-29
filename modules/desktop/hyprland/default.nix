## Hyprland WM ##
{
  config,
  inputs,
  ...
}: let
  inherit (config) util;
  inherit (config.flake) files;
  inherit (config.flake.modules) nixos homeManager;

  base = import ../_base.nix {};
  args = {inherit util files inputs;};
  features = map (p: import p args) (
    util.map.modules.list ../_wm
    ++ util.map.modules.list ./_features
  );
in {
  flake.modules = {
    nixos.hyprland.imports =
      [
        (base.nixos or {})
        nixos.qt
        nixos.gtk
      ]
      ++ map (f: f.nixos or {}) features;

    homeManager.hyprland.imports =
      [
        (base.home or {})
        homeManager.qt
        homeManager.gtk
      ]
      ++ map (f: f.home or {}) features
      ++ map (p: import p args) (util.map.modules.list ./_settings);
  };
}

## Hyprland WM ##
{
  config,
  inputs,
  ...
}: let
  inherit (config) util;
  inherit (config.flake) files;
  inherit (config.flake.modules) nixos homeManager;

  theme = {
    name = "catppuccin";
    name-alt = "Catppuccin";
    accent = "blue";
    variant = "macchiato";
    variant-alt = "Macchiato";
    icons = "Papirus-Dark";
  };

  base = import ../_base.nix {};
  args = {inherit util files inputs theme;};
  features = builtins.map (p: import p args) (util.map.modules.list ./_features);
  settings = builtins.map (p: import p args) (util.map.modules.list ./_settings);
in {
  flake.modules = {
    nixos.hyprland.imports =
      [
        (base.nixos or {})
        nixos.qt
        nixos.gtk
      ]
      ++ builtins.map (f: f.nixos or {}) features;

    homeManager.hyprland.imports =
      [
        (base.home or {})
        homeManager.qt
        homeManager.gtk
      ]
      ++ builtins.map (f: f.home or {}) features
      ++ settings;
  };
}

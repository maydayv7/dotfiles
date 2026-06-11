# Hyprland window manager
{
  config,
  inputs,
  ...
}: let
  inherit (config.flake) files;
  inherit (config) util;

  # Theme data (Catppuccin Macchiato Blue)
  theme = {
    name = "catppuccin";
    name-alt = "Catppuccin";
    accent = "blue";
    variant = "macchiato";
    variant-alt = "Macchiato";
    icons = "Papirus-Dark";
  };

  args = {inherit util files inputs theme;};

  # Per-feature modules export { nixos?, home? }
  features = builtins.map (p: import p args) (util.map.modules.list ./_hyprland/features);

  # Home-manager compositor settings (read system state via osConfig)
  settings = builtins.map (p: import p args) (util.map.modules.list ./_hyprland/settings);
in {
  flake.modules = {
    nixos.hyprland.imports =
      [./_base.nix]
      ++ builtins.map (f: f.nixos or {}) features;

    homeManager.hyprland.imports =
      builtins.map (f: f.home or {}) features
      ++ settings;
  };
}

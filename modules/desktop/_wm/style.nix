## Catppuccin Style
{
  inputs,
  files ? null,
  ...
}: {
  nixos = {pkgs, ...}: {
    environment.systemPackages = [pkgs.custom.cursors];
    stylix = {
      base16Scheme = files.colors.catppuccin;
      icons.package = pkgs.catppuccin-papirus-folders.override {
        accent = "blue";
        flavor = "macchiato";
      };
    };

    # QT Theme
    gui.qt = {
      theme = "catppuccin-macchiato-blue";
      package = pkgs.catppuccin-kvantum.override {
        accent = "blue";
        variant = "macchiato";
      };
    };
  };

  home = {
    config,
    lib,
    pkgs,
    options,
    ...
  }: let
    inherit (lib) attrNames elem filter genAttrs hasPrefix;
    theme = "${pkgs.custom.adw-catppuccin}/share/adw-catppuccin/macchiato";

    # Use Catppuccin over Stylix
    alias = {qt = "kvantum";};
    except = ["kitty"];
    targets = filter (n: !hasPrefix "_" n) (attrNames options.stylix.targets);
    derived = filter (t: elem (alias.${t} or t) (attrNames config.catppuccin) && !elem t except) targets;
  in {
    imports = [inputs.catppuccin.homeModules.catppuccin];
    config = {
      gui._unmanaged = derived ++ ["spicetify"];
      catppuccin =
        {
          enable = true;
          accent = "blue";
          flavor = "macchiato";
          hyprland.enable = false;
          gtk.icon.enable = false;
          firefox.force = true;
          kvantum.enable = false;
        }
        // genAttrs except (_: {enable = false;});

      # GTK Theme
      gtk = {
        gtk3.extraCss = builtins.readFile "${theme}/catppuccin-macchiato-blue-gtk3.css";
        gtk4.extraCss = builtins.readFile "${theme}/catppuccin-macchiato-blue.css";
      };
    };
  };
}

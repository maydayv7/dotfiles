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

    gui = {
      gtk.theme = {
        name = "catppuccin-macchiato-blue-standard";
        package = pkgs.catppuccin-gtk.override {
          accents = ["blue"];
          variant = "macchiato";
        };
      };

      qt = {
        style = "kvantum";
        theme = {
          name = "catppuccin-macchiato-blue";
          package = pkgs.catppuccin-kvantum.override {
            accent = "blue";
            variant = "macchiato";
          };
        };
      };
    };
  };

  home = {config, ...}: {
    imports = [inputs.catppuccin.homeModules.catppuccin];

    config = {
      # Theme
      catppuccin = {
        accent = "blue";
        flavor = "macchiato";

        brave.enable = config.programs.brave.enable or false;
        thunderbird.enable = config.programs.thunderbird.enable or false;
        obs.enable = config.programs.obs-studio.enable or false;
        vesktop.enable = config.programs.nixcord.vesktop.enable or false;
        vscode.profiles.default.enable = config.programs.vscode.enable or false;
      };

      # GTK Apps
      dconf.settings."org/gnome/desktop/wm/preferences" = {
        action-double-click-titlebar = "none";
        button-layout = "appmenu";
      };
    };
  };
}

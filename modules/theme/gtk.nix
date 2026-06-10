# GTK theming and configuration
## GTK Configuration ##
{config, ...}: let
  inherit (config.flake) files;
in {
  flake.modules.nixos.gtk = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit
      (lib)
      mkEnableOption
      mkIf
      mkOption
      types
      ;

    cfg = config.gui.gtk;
  in {
    options.gui.gtk = {
      enable = mkEnableOption "Enable GTK Configuration";
      theme = {
        name = mkOption {
          description = "GTK+ Application Theme";
          type = types.str;
        };

        package = mkOption {
          description = "GTK+ Theme Package";
          type = types.package;
        };
      };
    };

    config = mkIf cfg.enable {
      # Environment Setup
      programs.dconf.enable = true;
      services.dbus.packages = [pkgs.dconf];
      environment = {
        systemPackages = [cfg.theme.package];
        variables."GTK_THEME" = cfg.theme.name;
      };

      user.homeConfig = {
        home = {
          # Configuration
          persist.directories = [
            ".config/dconf"
            ".config/gtk-3.0"
            ".config/gtk-4.0"
          ];

          # Bookmarks
          file.".config/gtk-3.0/bookmarks" = {
            text = files.bookmarks;
            force = true;
          };
        };

        # Theming
        stylix.targets.gtk.enable = false;
        dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
        gtk = {
          enable = true;
          inherit (cfg) theme;
          cursorTheme = config.gui.cursors;
          font = with config.stylix.fonts; {
            inherit (sansSerif) package name;
            size = sizes.applications;
          };

          gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
          gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
        };
      };
    };
  };
}

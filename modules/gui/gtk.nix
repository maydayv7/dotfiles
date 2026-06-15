## GTK Configuration ##
{config, ...}: let
  inherit (config.flake) files;
in {
  flake.modules = {
    nixos.gtk = {
      config,
      lib,
      pkgs,
      ...
    }: let
      cfg = config.gui.gtk;
    in {
      options.gui.gtk.theme = {
        name = lib.mkOption {
          description = "GTK+ Application Theme";
          type = lib.types.str;
        };

        package = lib.mkOption {
          description = "GTK+ Theme Package";
          type = lib.types.package;
        };
      };

      config = {
        # Environment Setup
        programs.dconf.enable = true;
        services.dbus.packages = [pkgs.dconf];
        environment = {
          systemPackages = [cfg.theme.package];
          variables."GTK_THEME" = cfg.theme.name;
        };
      };
    };

    homeManager.gtk = {
      config,
      lib,
      osConfig ? null,
      ...
    }:
      lib.mkIf (osConfig != null) {
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
          inherit (osConfig.gui.gtk) theme;
          cursorTheme = config.stylix.cursor;
          font = with config.stylix.fonts; {
            inherit (sansSerif) package name;
            size = sizes.applications;
          };

          gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
          gtk4 = {
            inherit (osConfig.gui.gtk) theme;
            extraConfig.gtk-application-prefer-dark-theme = 1;
          };
        };
      };
  };
}

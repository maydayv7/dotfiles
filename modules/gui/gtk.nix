{
  config,
  lib,
  pkgs,
  files,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;
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

  ## GTK Configuration ##
  config = mkIf cfg.enable {
    # Environment Setup
    programs.dconf.enable = true;
    services.dbus.packages = [pkgs.dconf];
    environment = {
      systemPackages = [cfg.theme.package];
      variables."GTK_THEME" = cfg.theme.name;
    };

    # Desktop Integration
    programs.gnupg.agent.pinentryPackage = pkgs.pinentry-gtk2;

    user = {
      # Configuration
      persist.directories = [
        ".config/dconf"
        ".config/gtk-3.0"
        ".config/gtk-4.0"
      ];

      homeConfig = {
        # Bookmarks
        home.file.".config/gtk-3.0/bookmarks".text = files.gtk.bookmarks;

        # Theming
        dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
        gtk = {
          enable = true;
          inherit (cfg) theme;
          iconTheme = config.gui.icons;
          cursorTheme = config.gui.cursors;
          gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
          gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
        };
      };
    };
  };
}

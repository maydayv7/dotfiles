{
  config,
  lib,
  pkgs,
  files,
  ...
}: let
  inherit (lib) mkDefault mkEnableOption mkIf;
  cfg = config.gui;
in {
  options.gui.gtk.enable = mkEnableOption "Enable GTK Configuration";

  ## GTK Configuration ##
  config = mkIf cfg.gtk.enable {
    # Environment Setup
    programs.dconf.enable = true;
    services.dbus.packages = [pkgs.dconf];

    # Platform Integration
    programs.gnupg.agent.pinentryFlavor = "gtk2";
    environment = {
      systemPackages = [pkgs.libsForQt5.qtstyleplugin-kvantum];
      etc."xdg/Kvantum/kvantum.kvconfig".text = "[General]";
      variables = {
        "GTK_THEME" = cfg.theme.name;
        "QT_STYLE_OVERRIDE" = mkDefault "kvantum";
      };
    };

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
        gtk = {
          enable = true;
          inherit (cfg) theme;
          iconTheme = cfg.icons;
          cursorTheme = cfg.cursors;
          gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
          gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
        };
      };
    };
  };
}

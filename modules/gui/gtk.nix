{
  config,
  lib,
  pkgs,
  files,
  ...
}: let
  inherit (lib) mkDefault mkEnableOption mkIf;
in {
  options.gui.gtk.enable = mkEnableOption "Enable GTK Configuration";

  ## GTK Configuration ##
  config = mkIf config.gui.gtk.enable {
    # Environment Setup
    programs.dconf.enable = true;
    services.dbus.packages = [pkgs.dconf];
    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

    # Platform Integration
    programs.gnupg.agent.pinentryFlavor = "gtk2";
    environment = {
      variables."QT_STYLE_OVERRIDE" = mkDefault "kvantum";
      systemPackages = [pkgs.libsForQt5.qtstyleplugin-kvantum];
      etc."xdg/Kvantum/kvantum.kvconfig".text = "[General]";
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
          iconTheme = {
            name = "Papirus-Dark";
            package = pkgs.papirus-icon-theme;
          };

          gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
          gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
        };
      };
    };
  };
}

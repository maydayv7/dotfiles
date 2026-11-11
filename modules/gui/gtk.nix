## GTK Configuration ##
{config, ...}: let
  inherit (config.flake) files;
in {
  flake.modules = {
    nixos.gtk = {pkgs, ...}: {
      # Environment Setup
      programs.dconf.enable = true;
      services.dbus.packages = [pkgs.dconf];
      environment = {
        systemPackages = [pkgs.adw-gtk3];
        variables."GTK_THEME" = "adw-gtk3-dark";
      };
    };

    homeManager.gtk = {
      config,
      pkgs,
      ...
    }: {
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
      gui._unmanaged = ["gtk"];
      dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
      gtk = let
        theme = {
          name = "adw-gtk3-dark";
          package = pkgs.adw-gtk3;
        };
      in {
        enable = true;
        inherit theme;
        cursorTheme = config.stylix.cursor;
        font = with config.stylix.fonts; {
          inherit (sansSerif) package name;
          size = sizes.applications;
        };

        gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
        gtk4 = {
          inherit theme;
          extraConfig = {
            gtk-application-prefer-dark-theme = 1;

            # Font Render
            gtk-hint-font-metrics = 1;
            gtk-xft-hinting = 1;
            gtk-xft-hintstyle = "hintslight";
            gtk-xft-rgba = "rgb";
          };
        };
      };
    };
  };
}

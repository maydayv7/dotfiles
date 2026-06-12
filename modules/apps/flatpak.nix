## Flatpak Configuration ##
{inputs, ...}: {
  flake.modules = {
    nixos.flatpak = {
      config,
      lib,
      pkgs,
      ...
    }: {
      imports = [inputs.flatpak.nixosModules.nix-flatpak];

      xdg.portal.enable = true;
      system.activationScripts.updateDesktopDatabase.text = "${pkgs.desktop-file-utils}/bin/update-desktop-database /var/lib/flatpak/exports/share/applications";

      environment.persist.directories = ["/var/lib/flatpak"];

      services.flatpak = {
        enable = true;
        uninstallUnmanaged = true;

        remotes = [
          {
            name = "flathub";
            location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
          }
          {
            name = "flathub-beta";
            location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
          }
        ]
        ++ lib.optionals (config.services.desktopManager.gnome.enable or false) [
          {
            name = "gnome-nightly";
            location = "https://nightly.gnome.org/gnome-nightly.flatpakrepo";
          }
        ]
        ++ lib.optionals (config.services.desktopManager.pantheon.enable or false) [
          {
            name = "appcenter";
            location = "https://flatpak.elementary.io/repo.flatpakrepo";
          }
        ];

        packages = []
        ++ lib.optionals (config.services.desktopManager.gnome.enable or false) [
          {
            appId = "com.github.tchx84.Flatseal";
            origin = "flathub";
          }
        ]
        ++ lib.optionals (config.services.desktopManager.pantheon.enable or false) [
          {
            appId = "com.github.hezral.clips";
            origin = "appcenter";
          }
        ];

        overrides.global = {
          Context = {
            filesystems = [
              "~/.config/dconf:ro"
              "/run/current-system/sw/share/themes:ro"
            ];
            sockets = [
              "wayland"
              "!x11"
              "fallback-x11"
            ];
          };
          Environment = {
            "DCONF_USER_CONFIG_DIR" = ".config/dconf";
            "GTK_THEME" = config.gui.gtk.theme.name or "";
          };
        };

        update = {
          onActivation = false;
          auto.enable = false;
        };
      };
    };

    homeManager.flatpak = _: {
      home.persist.directories = [
        ".cache/flatpak"
        ".local/share/flatpak"
        ".var/app"
      ];
    };
  };
}

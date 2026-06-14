## Flatpak Configuration ##
{inputs, ...}: {
  flake.modules = {
    nixos.flatpak = {
      config,
      lib,
      pkgs,
      ...
    }: let
      isGnome = config.services.desktopManager.gnome.enable or false;
    in {
      imports = [inputs.flatpak.nixosModules.nix-flatpak];

      xdg.portal.enable = true;
      environment.persist.directories = ["/var/lib/flatpak"];
      system.activationScripts.updateDesktopDatabase.text = "${pkgs.desktop-file-utils}/bin/update-desktop-database /var/lib/flatpak/exports/share/applications";

      services.flatpak = {
        enable = true;
        uninstallUnmanaged = true;

        remotes =
          [
            {
              name = "flathub";
              location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
            }
            {
              name = "flathub-beta";
              location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
            }
          ]
          ++ lib.optionals isGnome [
            {
              name = "gnome-nightly";
              location = "https://nightly.gnome.org/gnome-nightly.flatpakrepo";
            }
          ];

        packages = [
          {
            appId = "com.github.tchx84.Flatseal";
            origin = "flathub";
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

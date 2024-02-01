{
  config,
  lib,
  inputs,
  ...
}: let
  enable = builtins.elem "flatpak" config.apps.list;
in {
  imports = [inputs.flatpak.nixosModules.nix-flatpak];

  ## Flatpak Configuration ##
  config = lib.mkIf enable {
    warnings = [
      ''
        Flatpak app install isn't Generational
        - Changes in package declaration will result in downloading them anew
      ''
    ];

    xdg.portal.enable = true;
    environment.persist.directories = ["/var/lib/flatpak"];
    user.persist.directories = [".cache/flatpak" ".local/share/flatpak" ".var/app"];

    services.flatpak = {
      enable = true;

      # Repositories
      remotes = [
        {
          name = "flathub";
          location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        }
        {
          name = "flathub-beta";
          location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
        }
      ];

      # Package List
      # Use `flatpak remote-info --log` to find commit revisions
      packages = [
        /*
        {
          appId = "";
          origin = "";
          commit = "";
        }
        */
      ];

      # Platform Integration
      overrides.global = {
        Context = {
          sockets = ["wayland" "!x11" "fallback-x11"];
          filesystems = ["~/.config/dconf:ro"];
        };

        Environment = {
          DCONF_USER_CONFIG_DIR = ".config/dconf";
          XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";
        };
      };

      # Package Updates
      update = {
        onActivation = false;
        auto.enable = false;
      };
    };
  };
}

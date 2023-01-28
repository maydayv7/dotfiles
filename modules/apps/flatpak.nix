{
  config,
  lib,
  pkgs,
  files,
  ...
}: let
  cfg = config.apps.flatpak;
  enable = builtins.elem "flatpak" config.apps.list;
  inherit (lib) flatpak mapAttrs' mapAttrsToList mkIf mkOption nameValuePair types;
  inherit (flatpak) fetchAppFromFlatHub fetchRuntimeFromFlatHub;

  ## Runtimes
  # Use `flatpak remote-info --log` to find commit revisions
  runtimes = with runtimes; {
    # Default Runtimes
    freedesktop = {
      locale = fetchRuntimeFromFlatHub {
        name = "org.freedesktop.Platform.Locale";
        branch = "22.08";
        commit = "3031f965fff14350b47aa5f26e17d79d52843d72afd81f59e77634a8a0d9b923";
        sha256 = "sha256-BQN/7S3pOyUA06HAH7lRYhXdCzDBcipC7fvac8TYoEc=";
      };
      h264 = fetchRuntimeFromFlatHub {
        name = "org.freedesktop.Platform.openh264";
        branch = "2.2.0";
        commit = "435b1135f46af01c742f7680e92a2ca2b63ef7f5cb6b75030caff3cdd80481a9";
        sha256 = "sha256-djUBvVehasXweG+DXgtoBpPb02OKLbx4stAnPGsopF4=";
      };
      gl = fetchRuntimeFromFlatHub {
        name = "org.freedesktop.Platform.GL.default";
        branch = "22.08";
        commit = "c1c025c27ef025aec874681c62ffe2939154fa032a7b12266b82e438946e9001";
        sha256 = "sha256-uNOg73pIQW5VAxscU1/1fz+eKl9qMXdkMXCG07CwVTs=";
      };
      vaapi = fetchRuntimeFromFlatHub {
        name = "org.freedesktop.Platform.VAAPI.Intel";
        branch = "22.08";
        commit = "31273448688ea085d7c88a8cf69127de931b952d6de9ca48704f6c5644012623";
        sha256 = "sha256-XE8IVtplLk7aVWdVxm8vrah/ZrPX+Om2M0YxfdyFHfU=";
      };
      platform = fetchRuntimeFromFlatHub {
        name = "org.freedesktop.Platform";
        branch = "22.08";
        runtime = with freedesktop; [gl locale h264 vaapi];
        commit = "2ce7932bdf087b4d9af01bfe47801aee69f23d64c1ea704621155a96e96fdbaf";
        sha256 = "sha256-7xWA8EujsYeARYk6svxT/YuY7LKhbsuiARIlgmABb8M=";
      };
    };

    # Specific Runtimes
    gnome = {
      locale = fetchRuntimeFromFlatHub {
        name = "org.gnome.Platform.Locale";
        branch = "43";
        commit = "4fbaaaa735433be40205ca5f79159b67e39ba61d8ab3383f08023eb6280c5c91";
        sha256 = "sha256-VGWxGFBK5b//6GEDog2A15BhewKcbIiSPQwc6l9DnIA=";
      };
      platform = fetchRuntimeFromFlatHub {
        name = "org.gnome.Platform";
        branch = "43";
        runtime = [freedesktop.platform gnome.locale];
        commit = "ff25bb0c5f8225e73b43cf40669f5935f68bbde67b00871e13f6c1261d6dc966";
        sha256 = "sha256-VOKendIOlCgkUtEMnsnD+DlIlYZ7ZoHKdj2V80l57JQ=";
      };
    };
  };
in {
  ## Flatpak Configuration ##
  options.apps.flatpak = {
    # Program Declaration
    programs = mkOption {
      type = with types;
        attrsOf (attrsOf (submodule ({options, ...}: {
          options = {
            name = mkOption {
              description = "Application Long Name";
              type = nonEmptyStr;
            };
            description = mkOption {
              description = "Application Description";
              type = str;
            };
            exec = mkOption {
              description = "Application Executable Command/Path";
              type = nonEmptyStr;
            };
            install = mkOption {
              description = "Application Derivation";
              type = package;
            };
          };
        })));
    };
  };

  config = mkIf enable {
    services.flatpak.enable = true;
    xdg.portal.enable = true;

    # Default Apps
    apps.flatpak.programs = with runtimes; {
      flatseal = {
        name = "Flatseal";
        exec = "com.github.tchx84.Flatseal";
        description = "Manage Flatpak Permissions";
        install = fetchAppFromFlatHub {
          name = "com.github.tchx84.Flatseal";
          runtime = [freedesktop.platform gnome.platform];
          commit = "7e76ba71421b243359a3bf168a8d5a1010575c7041ff135c163e73d7d50f0a96";
          sha256 = "sha256-Vx4joOwGJM5Jkpo/rmKlJ/4BvcxugvpOCwTMf/p3gMc=";
        };
      };
    };

    user = {
      persist.dirs = [".cache/flatpak" ".local/share/flatpak"];
      home = {
        # Repositories
        home.file.".local/share/flatpak/repo/config".text = files.flatpak.repos;

        # Application Wrapper
        home.packages = mapAttrsToList (_: name: name.install) cfg.programs;
        xdg.desktopEntries = mapAttrs' (app: value:
          with value;
            nameValuePair app {
              inherit name exec;
              comment =
                if (value ? description)
                then description
                else null;
              icon =
                if (value ? icon)
                then icon
                else exec;
              terminal = false;
              type = "Application";
            })
        cfg.programs;
      };
    };
  };
}

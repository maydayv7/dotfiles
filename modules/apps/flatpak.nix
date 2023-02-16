{
  config,
  lib,
  pkgs,
  files,
  ...
}: let
  cfg = config.apps.flatpak;
  enable = builtins.elem "flatpak" config.apps.list;
  inherit (flatpak) fetchAppFromFlatHub fetchRuntimeFromFlatHub;
  inherit (lib) flatpak mapAttrs' mapAttrsToList mkIf mkOption nameValuePair types;
in {
  ## Flatpak Configuration ##
  options.apps.flatpak = {
    # Program Declaration
    programs = mkOption {
      type = with types;
        attrsOf (submodule ({options, ...}: {
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
              apply = fetchAppFromFlatHub;
            };
          };
        }));
    };

    # Runtime Declaration
    runtimes = mkOption {
      type = with types;
        attrsOf (attrsOf package);
    };
  };

  config = mkIf enable {
    services.flatpak.enable = true;
    xdg.portal.enable = true;

    ## Default Runtimes
    # Use `flatpak remote-info --log` to find commit revisions
    apps.flatpak.runtimes = rec {
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
    };

    user = {
      persist.dirs =
        [".cache/flatpak" ".local/share/flatpak"]
        ++ mapAttrsToList (_: app: ".var/app/${app.install.name}") cfg.programs;

      home = {
        # Flatpak Settings
        home.file = with files.flatpak; {
          ".local/share/flatpak/repo/config".text = repos;
          ".local/share/flatpak/overrides/global".text = overrides;
        };

        # Application Wrapper
        home.packages = [
          (
            pkgs.buildEnv
            {
              name = "FlatPakEnv";
              paths = mapAttrsToList (_: name: name.install) cfg.programs;
            }
          )
        ];
        xdg.desktopEntries = mapAttrs' (app: value:
          with value; let
            exec = value.install.name;
          in
            nameValuePair app {
              inherit name exec;
              comment = mkIf (value ? description) description;
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

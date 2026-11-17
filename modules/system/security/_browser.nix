# Browser Sandbox
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  appId = "org.mozilla.firefox";
  firefox = config.programs.firefox.finalPackage;
  sandbox = (inputs.nixpak.lib.nixpak {inherit lib pkgs;}) {
    config = {sloth, ...}: {
      app = {
        package = firefox;
        binPath = "bin/firefox";
      };
      flatpak.appId = appId;

      locale.enable = true;
      etc.sslCertificates.enable = true;
      gpu = {
        enable = true;
        provider = "nixos";
      };

      dbus = {
        policies = {
          "${appId}" = "own";
          "${appId}.*" = "own";
          "org.mpris.MediaPlayer2.firefox.*" = "own";
          "org.freedesktop.portal.Desktop" = "talk";
          "org.freedesktop.portal.Documents" = "talk";
          "org.freedesktop.Notifications" = "talk";
          "org.a11y.Bus" = "talk";
        };
      };

      bubblewrap = {
        tmpfs = ["/tmp"];
        network = true;
        newSession = true;
        clearEnv = true;
        env =
          lib.genAttrs [
            "HOME"
            "PATH"
            "XDG_RUNTIME_DIR"
            "WAYLAND_DISPLAY"
          ]
          sloth.env
          // lib.genAttrs [
            "USER"
            "LOGNAME"
            "LANG"
            "LC_ALL"
            "LC_CTYPE"
            "GTK_THEME"
            "GTK_USE_PORTAL"
            "GTK_PATH"
            "GTK_A11Y"
            "XCURSOR_THEME"
            "XCURSOR_SIZE"
            "XCURSOR_PATH"
            "XDG_CONFIG_DIRS"
            "XDG_DATA_DIRS"
            "XDG_CURRENT_DESKTOP"
            "XDG_SESSION_TYPE"
            "XDG_SESSION_DESKTOP"
            "__NV_PRIME_RENDER_OFFLOAD"
            "__GLX_VENDOR_LIBRARY_NAME"
            "__VK_LAYER_NV_optimus"
          ] (name: sloth.envOr name "")
          // {
            XDG_CONFIG_HOME = sloth.xdgConfigHome;
            XDG_CACHE_HOME = sloth.xdgCacheHome;
            XDG_DATA_HOME = sloth.xdgDataHome;
            XDG_STATE_HOME = sloth.xdgStateHome;
            MOZ_ENABLE_WAYLAND = "1";
          };

        sockets = {
          wayland = true;
          pulse = true;
          x11 = false;
        };

        bind = {
          rw = [
            (sloth.mkdir (sloth.concat' sloth.xdgConfigHome "/mozilla/firefox"))
            (sloth.mkdir (sloth.concat' sloth.xdgCacheHome "/mozilla"))
            sloth.xdgDownloadDir

            (sloth.concat' sloth.runtimeDir "/at-spi/bus")
            [
              (sloth.concat' sloth.runtimeDir "/doc/by-app/${appId}")
              (sloth.concat' sloth.runtimeDir "/doc")
            ]
            (sloth.concat' sloth.runtimeDir "/gvfsd")
            (sloth.concat' sloth.xdgCacheHome "/fontconfig")

            (sloth.concat' sloth.runtimeDir "/app/org.keepassxc.KeePassXC")
          ];

          ro = [
            "/sys/bus/pci"
            "/sys/class/drm"
            "/run/udev/data"
            "/etc/egl/egl_external_platform.d"
            ["${firefox}/lib/firefox" "/app/etc/firefox"]
            (sloth.concat' sloth.homeDir "/.mozilla/native-messaging-hosts")

            "/run/current-system"
            "/etc/profiles/per-user/${config.home.username}"
            "/etc/xdg"

            (sloth.concat' sloth.xdgDataHome "/icons")
            (sloth.concat' sloth.xdgConfigHome "/gtk-3.0")
            (sloth.concat' sloth.xdgConfigHome "/gtk-4.0")
            (sloth.concat' sloth.xdgConfigHome "/fontconfig")
            (sloth.concat' sloth.xdgConfigHome "/dconf")
            "/etc/fonts"
            "/etc/localtime"
            "/etc/zoneinfo"
          ];

          dev = [
            "/dev/nvidia0"
            "/dev/nvidiactl"
            "/dev/nvidia-modeset"
            "/dev/nvidia-uvm"
          ];
        };
      };
    };
  };
in {
  config = lib.mkIf config.programs.firefox.enable {
    home.packages = [(lib.hiPrio sandbox.config.env)];
  };
}

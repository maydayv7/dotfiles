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

      gpu = {
        enable = true;
        provider = "nixos";
      };
      locale.enable = true;
      etc.sslCertificates.enable = true;
      dbus = {
        policies = {
          "${appId}" = "own";
          "${appId}.*" = "own";
          "org.mpris.MediaPlayer2.${appId}.*" = "own";
          "org.freedesktop.DBus" = "talk";
          "ca.desrt.dconf" = "talk";
          "org.freedesktop.portal.Desktop" = "talk";
          "org.freedesktop.portal.Documents" = "talk";
          "org.freedesktop.portal.FileChooser" = "talk";
          "org.freedesktop.portal.Notification" = "talk";
          "org.freedesktop.portal.OpenURI" = "talk";
          "org.freedesktop.portal.ScreenCast" = "talk";
          "org.freedesktop.portal.Camera" = "talk";
          "org.freedesktop.portal.Request" = "talk";
          "org.freedesktop.Notifications" = "talk";
          "org.kde.StatusNotifierWatcher" = "talk";
          "org.a11y.Bus" = "talk";
        };
        rules.broadcast."org.freedesktop.portal.*" = ["@/org/freedesktop/portal/*"];
        args = ["--filter" "--sloppy-names"];
      };

      bubblewrap = {
        network = true;
        sockets = {
          wayland = true;
          pipewire = true;
          pulse = true;
          x11 = false;
        };

        bind.rw = [
          (sloth.mkdir (sloth.concat' sloth.xdgConfigHome "/mozilla/firefox"))
          (sloth.mkdir (sloth.concat' sloth.xdgCacheHome "/mozilla"))
          sloth.xdgDownloadDir

          (sloth.concat' sloth.runtimeDir "/at-spi/bus")
          (sloth.concat' sloth.runtimeDir "/doc")
          (sloth.concat' sloth.runtimeDir "/gvfsd")
          (sloth.concat' sloth.xdgCacheHome "/fontconfig")

          (sloth.concat' sloth.runtimeDir "/app/org.keepassxc.KeePassXC")
        ];

        bind.ro = [
          "/sys/bus/pci"
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

        bind.dev = ["/dev/shm"];
        tmpfs = ["/tmp"];
        newSession = true;
      };
    };
  };
in {
  config = lib.mkIf config.programs.firefox.enable {
    home.packages = [(lib.hiPrio sandbox.config.env)];
  };
}

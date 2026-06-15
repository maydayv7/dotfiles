{
  util ? null,
  files ? null,
  ...
}: {
  nixos = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      # Apps
      clipse
      font-manager
      gnome-clocks
      gnome-disk-utility
      nwg-drawer
      overskride
      qalculate-gtk
      remmina
      resources
      smile

      # Utilities
      custom.sysutils
      hyprpicker
      pwvucontrol
      sunsetr
      wev
      wl-clipboard
      wl-screenrec
      wlclock
      wlr-randr

      # Network Settings
      (gnome-control-center.overrideAttrs (old: {
        postInstall =
          old.postInstall
          + ''
            dir=$out/share/applications
            for panel in $dir/*
            do
              [ "$panel" = "$dir/gnome-network-panel.desktop" ] && continue
              [ "$panel" = "$dir/gnome-wifi-panel.desktop" ] && continue
              [ "$panel" = "$dir/gnome-wwan-panel.desktop" ] && continue
              [ "$panel" = "$dir/gnome-sharing-panel.desktop" ] && continue
              [ "$panel" = "$dir/gnome-wacom-panel.desktop" ] && continue
              rm "$panel"
            done
          '';
      }))
    ];

    ## Essential Utilities
    # Power
    services = {
      power-profiles-daemon.enable = true;
      upower.enable = true;
    };

    # Backlight
    hardware.brillo.enable = true;
  };

  home = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (lib) getExe;
    inherit (config.lib.stylix) colors;
  in {
    xdg.mimeApps.defaultApplications = util.build.mime {
      font = ["com.github.FontManager.FontViewer.desktop"];
    };

    # Display Temperature
    home.file.".config/sunsetr".source = files.sunsetr;

    # Desktop Clock
    systemd.user.services.wlclock = let
      target = ["graphical-session.target"];
    in {
      Install.WantedBy = target;
      Unit = {
        Description = "Desktop Clock";
        After = target;
      };
      Service.ExecStart = with colors; "${getExe pkgs.wlclock} --layer bottom --exclusive-zone true --position top-right --margin 10 --size 300 --corner-radius 10 --border-size 2 --hand-width 7 --marking-width 3 --background-colour #${base00}4d --clock-colour #${base0D} --border-colour #${base00}";
    };

    # Network Settings
    xdg.desktopEntries."org.gnome.Settings" = {
      name = "Network Settings";
      comment = "Gnome Control Center";
      icon = "org.gnome.Settings";
      exec = "env XDG_CURRENT_DESKTOP=gnome gnome-control-center";
      categories = ["X-Preferences"];
      terminal = false;
    };
  };
}

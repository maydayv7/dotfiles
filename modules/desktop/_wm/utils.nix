## Utilities
{util ? null, ...}: {
  nixos = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      # Apps
      font-manager
      gnome-clocks
      gnome-disk-utility
      overskride
      qalculate-gtk
      remmina
      resources

      # Utilities
      hyprpicker
      nwg-displays
      pwvucontrol
      wev
      wl-clipboard
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

    programs = {
      # Phone Connect
      kdeconnect.enable = true;

      # Screen Record
      gpu-screen-recorder.enable = true;
    };
  };

  home = _: {
    home = {
      persist.directories = [
        ".config/kdeconnect"
        ".config/gpu-screen-recorder"
        ".config/nwg-displays"
        ".local/share/gpu-screen-recorder"
      ];

      file.".config/kwalletrc".text = ''
        [Wallet]
        Enabled=false
      '';
    };

    # Phone Connect
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };

    xdg = {
      mimeApps.defaultApplications = util.build.mime {
        font = ["com.github.FontManager.FontViewer.desktop"];
      };

      # Network Settings
      desktopEntries."org.gnome.Settings" = {
        name = "Network Settings";
        comment = "Gnome Control Center";
        icon = "org.gnome.Settings";
        exec = "env XDG_CURRENT_DESKTOP=gnome gnome-control-center";
        categories = ["X-Preferences"];
        terminal = false;
      };
    };
  };
}

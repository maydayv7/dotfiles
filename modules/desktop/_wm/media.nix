## Media
{util ? null, ...}: {
  nixos = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      celluloid
      lollypop
      papers
      pix
      playerctl
      transmission_4-gtk
    ];
  };

  home = {pkgs, ...}: {
    # Default Applications
    xdg.mimeApps.defaultApplications = util.build.mime {
      audio = ["org.gnome.Lollypop.desktop"];
      document = ["org.gnome.Papers.desktop"];
      image = ["pix.desktop"];
      magnet = ["transmission-gtk.desktop"];
      pdf = ["org.gnome.Papers.desktop"];
      video = ["io.github.celluloid_player.Celluloid.desktop"];
    };

    # Persisted Files
    home.persist.directories = [
      ".config/mpv"
      ".local/share/lollypop"
      ".config/pix"
      ".local/share/pix"
      ".cache/pix"
    ];

    # Media Player
    services.playerctld.enable = true;
    programs.mpv = {
      enable = true;
      defaultProfiles = ["gpu-hq"];
      scripts = [pkgs.mpvScripts.mpris];
    };
  };
}

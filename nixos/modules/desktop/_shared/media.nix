{
  config,
  lib,
  util,
  pkgs,
  ...
}:
{
  ## Media Configuration
  config = lib.mkIf config._shared.enable {
    environment.systemPackages = with pkgs; [
      celluloid
      lollypop
      papers
      playerctl
      shotwell
      transmission_4-gtk
    ];

    user.homeConfig = {
      # Default Applications
      xdg.mimeApps.defaultApplications = util.build.mime {
        audio = [ "org.gnome.Lollypop.desktop" ];
        document = [ "org.gnome.Papers.desktop" ];
        image = [ "org.gnome.Shotwell-Viewer.desktop" ];
        magnet = [ "transmission-gtk.desktop" ];
        pdf = [ "org.gnome.Papers.desktop" ];
        video = [ "io.github.celluloid_player.Celluloid.desktop" ];
      };

      # Persisted Files
      home.persist.directories = [
        ".config/mpv"
        ".config/shotwell"
        ".local/share/lollypop"
        ".local/share/shotwell"
        ".cache/shotwell"
      ];

      # Media Player
      services.playerctld.enable = true;
      programs.mpv = {
        enable = true;
        defaultProfiles = [ "gpu-hq" ];
        scripts = [ pkgs.mpvScripts.mpris ];
      };
    };
  };
}

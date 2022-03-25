pkgs: {
  name = "Video";
  shellHook = ''echo "## Video Editing Shell ##"'';
  packages = with pkgs; [
    audacity
    blender
    ffmpeg
    handbrake
    mpv
    obs-studio
    youtube-dl
  ];
}

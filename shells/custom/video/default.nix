{ pkgs }:
pkgs.mkShell
{
  name = "Video";
  nativeBuildInputs = with pkgs; [ audacity blender ffmpeg handbrake mpv obs-studio youtube-dl ];
  shellHook = ''echo "## Video Editing Shell" ##'';
}

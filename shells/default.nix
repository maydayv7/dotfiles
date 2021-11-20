{ pkgs }:
{
  ## Tailored Developer Shells ##
  # Video Editing Shell
  video = import ./video.nix { inherit pkgs; };
}

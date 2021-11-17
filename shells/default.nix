{ pkgs }:
{
  ## Tailored Developer Shells ##
  # Video Editing Shell
  video = import ./video { inherit pkgs; };
}

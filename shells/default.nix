{ pkgs, ... }:
pkgs.mkShell
{
  # Default Developer Shell
  name = "devShell";

  # Required Packages
  buildInputs = with pkgs;
  [
    git
    git-crypt
    gnupg
  ];

  # Init Script
  shellHook =
  ''
    echo "## Default Developer Shell ##"
  '';
}

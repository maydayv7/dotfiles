{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell
{
  name = "DevShell";

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
    echo "######################### Welcome to the Nix Developer Shell #########################"
  '';
}

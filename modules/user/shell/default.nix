{ lib, ... }:
rec
{
  imports =
  [
    ./git.nix
    ./zsh.nix
  ];
}

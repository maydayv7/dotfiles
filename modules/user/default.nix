{ pkgs, ... }:
{
  # Custom User Configuration Modules
  imports =
  [
    ./dotfiles
    ./shell
  ];
}

{ pkgs, ... }:
{
  # Custom System Configuration Modules
  imports =
  [
    ./base
    ./gui
    ./hardware
    ./scripts
  ];
}

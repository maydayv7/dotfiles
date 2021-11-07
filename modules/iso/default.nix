{ pkgs, ... }:
{
  # Custom Install Media Configuration Modules
  imports =
  [
    ./base
    ./gui
    ./scripts
  ];
}

{ pkgs, ... }:
{
  # Custom User Configuration Modules
  imports =
  [
    ./home
    ./shell
  ];
}

{ ... }:
{
  # Custom Device Configuration Modules
  imports =
  [
    ./apps
    ./base
    ./gui
    ./hardware
    ./shell
    ../scripts
    ../secrets
  ];
}

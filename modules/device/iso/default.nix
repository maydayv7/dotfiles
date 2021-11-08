{ ... }:
{
  # Custom Install Media Configuration Modules
  imports =
  [
    ../base
    ../gui
    ../scripts
    ./packages
    ./user
  ];
}

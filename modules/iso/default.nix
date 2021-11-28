{ modulesPath, ... }:
rec
{
  imports =
  [
    ./user.nix

    # Install Media Build Module
    "${modulesPath}/installer/cd-dvd/iso-image.nix"
  ];
}

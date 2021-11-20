{ lib, ... }:
rec
{
  imports =
  [
    ./filesystem.nix
    ./ssd.nix
  ];
}

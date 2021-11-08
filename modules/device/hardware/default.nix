{ lib, ... }:
rec
{
  imports =
  [
    ./boot
    ./filesystem
    ./ssd
  ];
}

{ lib, ... }:
rec
{
  imports =
  [
    ./install
    ./management
    ./setup
  ];
}

{ config, lib, pkgs, ... }:
{
  # Security Settings
  security =
  {
    sudo.extraConfig =
    "
      Defaults pwfeedback
    ";
  };
}

{ config, lib, pkgs, ... }:
{
  ## Android Compatibilty Configuration ##
  # Android Device Bridge
  programs.adb.enable = true;
}

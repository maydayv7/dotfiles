{ pkgs, ... }:
{
  # Custom System Configuration Modules
  imports = (import ./base) ++ (import ./gui) ++ (import ./hardware) ++ (import ./scripts);
}

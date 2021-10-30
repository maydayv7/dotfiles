{ pkgs, ... }:
{
  # Custom Install Media Configuration Modules
  imports = (import ./base) ++ (import ./gui) ++ (import ./scripts);
}

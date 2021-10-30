{ pkgs, ... }:
{
  # Custom User Configuration Modules
  imports = (import ./home) ++ (import ./shell);
}

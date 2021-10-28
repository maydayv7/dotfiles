{ pkgs, ... }:
{
  # Custom-Made User Configuration Modules
  imports = (import ./home) ++ (import ./shell);
}

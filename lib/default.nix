{ systems, lib, inputs } @ args:
{
  map = import ./map.nix args;
  package = import ./package.nix args;
  xdg = import ./xdg.nix args;
}

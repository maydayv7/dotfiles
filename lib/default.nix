{ systems, lib, inputs } @ args:
{
  build = import ./build.nix args;
  map = import ./map.nix args;
  pack = import ./pack.nix args;
  xdg = import ./xdg.nix args;
}

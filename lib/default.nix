{ systems, lib, inputs } @ args:
{
  build = import ./build.nix args;
  map = import ./map.nix args;
  xdg = import ./xdg.nix args;
}

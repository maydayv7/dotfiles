pkgs: {
  name = "Formatter";
  shellHook = ''echo "## Formatting Shell ##"'';
  packages = (import ../lib/map.nix {lib = pkgs.lib;}).array (import ../modules/nix/format.nix) pkgs;
}

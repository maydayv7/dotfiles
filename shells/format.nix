pkgs: {
  name = "Formatter";
  shellHook = ''echo "## Formatting Shell ##"'';
  packages = (import ../lib/map.nix {inherit (pkgs) lib;}).array (import ../modules/nix/format.nix) pkgs;
}

pkgs: {
  name = "Lua";
  shellHook = ''echo "## Lua Development Shell ##"'';
  packages = with pkgs; [lua luaPackages.moonscript];
}

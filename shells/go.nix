pkgs: {
  name = "Go";
  shellHook = ''echo "## Go Development Shell ##"'';
  packages = with pkgs; [ go delve go-outline goimports godef golint gopls ];
}

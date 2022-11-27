pkgs: {
  name = "Go";
  shellHook = ''echo "## Go Development Shell ##"'';
  packages = with pkgs; [go delve go-outline godef golint gopls gotools];
}

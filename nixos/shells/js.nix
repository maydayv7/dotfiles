pkgs: {
  name = "JS";
  shellHook = ''echo "## JavaScript Development Shell ##"'';
  packages = with pkgs; [
    nodejs
    typescript

    eslint
    nodemon
    postman
  ];
}

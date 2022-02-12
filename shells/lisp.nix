pkgs: {
  name = "Lisp";
  shellHook = ''echo "## Lisp Development Shell ##"'';
  packages = with pkgs; [ sbcl lispPackages.quicklisp ];
}

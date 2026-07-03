pkgs: {
  name = "Python";
  shellHook = ''echo "## Python Development Shell ##"'';
  packages = [
    pkgs.python3
    (pkgs.python3.withPackages (
      p:
        with p; [
          pip
          poetry-core
          setuptools
          ruff

          ipython
          matplotlib
          numpy
          pandas
        ]
    ))
  ];
}

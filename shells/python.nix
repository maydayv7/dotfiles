pkgs: {
  name = "Python";
  packages = with pkgs;
  with python39Packages; [
    python39
    ipython
    pip
    poetry-core
    pylint
    setuptools
  ];

  shellHook = ''
    echo "## Python Development Shell ##"
    PYTHON_DIR="$XDG_DATA_HOME/python"
    export PYTHONSTARTUP="$PYTHON_DIR/pythonrc";
    export PIP_CONFIG_FILE="$PYTHON_DIR/pip/pip.conf";
    export PIP_LOG_FILE="$PYTHON_DIR/pip/log";
    export PYLINTHOME="$PYTHON_DIR/pylint";
    export PYLINTRC="$PYTHON_DIR/pylint/pylintrc";
    export IPYTHONDIR="$PYTHON_DIR/ipython";
  '';
}

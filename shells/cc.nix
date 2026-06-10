pkgs: {
  name = "C";
  packages = with pkgs; [
    clang
    cmake
    gcc
    gdb
    libcxx
  ];

  shellHook = ''echo "## C/C++ Development Shell ##"'';
  LIBCLANG_PATH = "${pkgs.libclang}/lib";
}

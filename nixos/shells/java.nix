pkgs: {
  name = "Java";
  packages = [pkgs.jdk];
  shellHook = ''echo "## Java Development Shell ##"'';
  JAVA_HOME = pkgs.jdk;
}

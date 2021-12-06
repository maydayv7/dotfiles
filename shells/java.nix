{ pkgs, ... }:
pkgs.mkShell
{
  name = "Java";
  shellHook = '' echo "## Java Development Shell ##" '';
  nativeBuildInputs = with pkgs;
  [
    jdk
    nodejs
  ];
}

{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  name = "devShell";
  shellHook = ''echo "## Default Developer Shell ##" '';
  buildInputs = with pkgs; [ git git-crypt gnupg ];
}

{ pkgs ? import <nixpkgs> { }, ... }:
pkgs.mkShell {
  name = "devShell";
  buildInputs = with pkgs; [ git git-crypt gnupg ];
  shellHook = ''
    echo -e "\e[36m## Default Developer Shell ##"
    echo -e "\e[34m   Version: $(nix --version)"
  '';
}

{ pkgs ? import <nixpkgs> { }, ... }:
pkgs.mkShell {
  name = "devShell";
  packages = with pkgs; [ dbus git git-crypt gnupg ncurses shellcheck ];
  shellHook = ''
    echo -e "\e[36m## Default Developer Shell ##"
    echo -e "\e[34m   Version: $(nix --version)"
  '';
}

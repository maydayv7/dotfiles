{ pkgs ? import <nixpkgs> { }, ... }:
pkgs.mkShell {
  name = "devShell";
  packages = with pkgs; [ dbus figlet git git-crypt gnupg jq shellcheck ];
  shellHook = ''
    echo -e "\e[36m## Default Developer Shell ##"
    echo -e "\e[34m   Version: $(nix --version)"
  '';
}

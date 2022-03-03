{pkgs ? import ../., ...}:
pkgs.mkShell {
  name = "devShell";
  packages = with pkgs; [figlet git git-crypt gnupg jq shellcheck sops];
  shellHook = ''
    echo -e "\e[36m## Default Developer Shell ##"
    echo -e "\e[34m   Version: $(nix --version)"
  '';
}

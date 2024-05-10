{pkgs ? import ../packages, ...}:
with pkgs;
  mkShell {
    name = "devShell";
    packages = [git gnupg jq nixFlakes sops treefmt] ++ [figlet hyfetch];
    shellHook = ''
      echo -e "\e[36m## Default Developer Shell ##"
      echo -e "\e[34m   Version: $(nix --version)"
    '';
  }

{pkgs ? import ../packages, ...}:
with pkgs;
  mkShell {
    name = "devShell";
    packages = [git gnupg jq sops treefmt] ++ [figlet neofetch];
    shellHook = ''
      echo -e "\e[36m## Default Developer Shell ##"
      echo -e "\e[34m   Version: $(nix --version)"
    '';
  }

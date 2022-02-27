pkgs: {
  name = "Formatter";
  shellHook = ''echo "## Formatting Shell ##"'';
  packages = with pkgs; [
    unstable.alejandra
    figlet
    jq
    nix-linter
    nodePackages.prettier
    shellcheck
    statix
  ];
}
